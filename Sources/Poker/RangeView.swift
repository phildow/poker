//
//  RangeView.swift
//  Preflop Drills
//
//  Created by Philip Dow on 4/29/21.
//

//  TODO: Option to visually indicate selected cell
//  TODO: Rename to UntypedDistributionView?

#if os(macOS)
import Cocoa
#elseif os(iOS)
import UIKit
#endif

/// The RangeViewDatasource vends distributions to the range view

public protocol RangeViewDataSource: AnyObject {
    func distribution(view: RangeView, for hand: UntypedHand) -> UntypedHand.Distribution
}

#if os(macOS)

/// The RangeViewDelegate will be informed as the user paints a range. macOS only

public protocol RangeViewDelegate: AnyObject {
    func didBeginPainting(_ view: RangeView, hand: UntypedHand, flags: RangeView.PaintFlags)
    func didPaint(_ view: RangeView, hand: UntypedHand, flags: RangeView.PaintFlags)
    func didFinishPainting(_ view: RangeView, hand: UntypedHand?, flags: RangeView.PaintFlags)
}

#endif

#if os(macOS)
public typealias PlatformView = NSView
public typealias PlatformColor = NSColor
public typealias PlatformFont = NSFont
#elseif os(iOS)
public typealias PlatformView = UIView
public typealias PlatformColor = UIColor
public typealias PlatformFont = UIFont
#endif

private let defaultDistribution = UntypedHand.Distribution(hand: "", raise: 0, call: 0, fold: 0, notInRange: 1)

/// A RangeView displays the distribution of actions for all HoldEm starting hands
///
/// On iOS the coordinate system (0,0) starts at the top left and grows down whereas on macOS it starts at the bottom left and grows up.
/// Adjust by beginning most y coordinates with `bounds.maxY - {val}` and adjusting once more for height of element

public class RangeView: PlatformView {
    
    public struct Theme {
        public let notInRangeColor: PlatformColor
        public let raiseColor: PlatformColor
        public let callColor: PlatformColor
        public let foldColor: PlatformColor
        public let gridColor: PlatformColor
        public let labelColor: PlatformColor
        
        public init(notInRangeColor: PlatformColor, raiseColor: PlatformColor, callColor: PlatformColor, foldColor: PlatformColor, gridColor: PlatformColor, labelColor: PlatformColor) {
            self.notInRangeColor = notInRangeColor
            self.raiseColor = raiseColor
            self.callColor = callColor
            self.foldColor = foldColor
            self.gridColor = gridColor
            self.labelColor = labelColor
        }
    }
    
    public static let defaultTheme = Theme(
        notInRangeColor: PlatformColor(white: 0.1, alpha: 1.0),
        raiseColor: PlatformColor(displayP3Red: 227.0/255.0, green: 92.0/255.0, blue: 41.0/255.0, alpha: 1.0),
        callColor: PlatformColor(displayP3Red: 67.0/255.0, green: 155.0/255.0, blue: 29.0/255.0, alpha: 1.0),
        foldColor: PlatformColor(displayP3Red: 67.0/255.0, green: 155.0/255.0, blue: 223.0/255.0, alpha: 1.0),
        gridColor: PlatformColor(white: 0.95, alpha: 1),
        labelColor: PlatformColor(white: 0.95, alpha: 1)
        )
    
    #if os(macOS)
    
    public struct PaintFlags: OptionSet {
        public let rawValue: Int
        
        public static let none         = PaintFlags([])
        public static let dragging     = PaintFlags(rawValue: 1 << 0)
        public static let cmdKeyDown   = PaintFlags(rawValue: 1 << 1)
        public static let shiftKeyDown = PaintFlags(rawValue: 1 << 2)
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
    
    #endif
    
    public weak var dataSource: RangeViewDataSource?
    
    #if os(macOS)
    public weak var delegate: RangeViewDelegate?
    #endif
    
    public var theme = defaultTheme {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    #if os(macOS)
    
    public var backgroundColor: PlatformColor = PlatformColor.white {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    #endif
    
    #if os(macOS)
    
    /// True to visually indicate a distribution is invalid, false otherwise. macOS only
    
    public var indicatesInvalidDistribution = false {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    #endif
    
    /// True to center the view vertically, false otherwise
    
    public var centerVertically = true {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    /// True to center the view horizontally, false otherwise
    
    public var centerHorizontally = true {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    /// Total offset used to center the chart along the vertical and horizontal axis
    
    private var centerOffset: CGPoint {
        return CGPoint(x: centerXOffset, y: centerYOffset)
    }
    
    /// Used to center chart in view along the horizontal axis
    
    private var centerXOffset: CGFloat {
        if !centerHorizontally {
            return 0
        }
        
        let frame = chartFrame
        
        if frame.size.width < bounds.size.width {
            return (bounds.size.width - frame.size.width) / 2
        } else {
            return 0
        }
    }
    
    /// Used to center chart in view along the vertical axis
    
    private var centerYOffset: CGFloat {
        if !centerVertically {
            return 0
        }
        
        let frame = chartFrame
        
        if frame.size.height < bounds.size.height {
            #if os(macOS)
            return -((bounds.size.height - frame.size.height) / 2)
            #elseif os(iOS)
            return (bounds.size.height - frame.size.height) / 2
            #endif
        } else {
            return 0
        }
    }
    
    /// The natural bounds for the chart prior to any center x or center y offsetting
    
    private var chartFrame: CGRect {
        #if os(macOS)
        return CGRect(x: 0, y: bounds.maxY - edge * 13, width: edge * 13, height: edge * 13)
        #elseif os(iOS)
        return CGRect(x: 0, y: 0, width: edge * 13, height: edge * 13)
        #endif
    }
    
    /// The length of the side of a single cell in the chart.
    
    private var edge: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 13.0
    }
    
    #if os(macOS)
    
    /// Returns a bitmap representation of the chart
    
    public var bitmap: NSBitmapImageRep? {
        let frame = chartFrame.insetBy(dx: -1, dy: -1).offsetBy(dx: centerOffset.x, dy: centerOffset.y)
        let bmp = bitmapImageRepForCachingDisplay(in: frame)!
        cacheDisplay(in: frame, to: bmp)
        return bmp
    }
    
    #endif
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    private func sharedInit() {
        #if os(iOS)
        self.backgroundColor = PlatformColor.white
        #endif
    }
    
    #if os(macOS)
    
    public override var acceptsFirstResponder: Bool {
        return true
    }
    
    #endif
    
    // MARK: - Draw
    
    public override func draw(_ rect: CGRect) {
        #if os(macOS)
        guard let context = NSGraphicsContext.current?.cgContext else {
            return
        }
        #elseif os(iOS)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        #endif
        
        let fontSize = edge / 3.0
        
        // Draw Action
        
        for i in 0...12 { for j in 0...12 {
            let index = i*13+j
            let hand = HoldEm.StartingHands[index]
            let distribution = dataSource?.distribution(view: self, for: hand) ?? defaultDistribution
            
            let frame = bounds(for: index)
            
            let notInRangeFrame = frame
            let foldFrame = CGRect(
                x: frame.origin.x,
                y: frame.origin.y,
                width: CGFloat((distribution.raise+distribution.call+distribution.fold))*frame.size.width,
                height: frame.size.height)
            let callFrame = CGRect(
                x: frame.origin.x,
                y: frame.origin.y,
                width: CGFloat((distribution.raise+distribution.call))*frame.size.width,
                height: frame.size.height)
            let raiseFrame = CGRect(
                x: frame.origin.x,
                y: frame.origin.y,
                width: CGFloat((distribution.raise))*frame.size.width,
                height: frame.size.height)
            
            context.saveGState()
            context.clip(to: frame)
            
            context.setFillColor(maybeInverting(color: theme.notInRangeColor, for: distribution).cgColor)
            context.fill(notInRangeFrame)
            
            context.setFillColor(maybeInverting(color: theme.foldColor, for: distribution).cgColor)
            context.fill(foldFrame)
            
            context.setFillColor(maybeInverting(color: theme.callColor, for: distribution).cgColor)
            context.fill(callFrame)
            
            context.setFillColor(maybeInverting(color: theme.raiseColor, for: distribution).cgColor)
            context.fill(raiseFrame)
            
            context.restoreGState()
        }}
        
        // Draw Grid
        
        context.setStrokeColor(theme.gridColor.cgColor)
        context.setLineWidth(1)
        
        let frame = chartFrame.offsetBy(dx: centerOffset.x, dy: centerOffset.y)
        context.stroke(frame)
        
        for i in 0...12 {
            #if os(macOS)
            context.move(to: CGPoint(x: CGFloat(i) * edge, y: bounds.maxY).offsetBy(dx: centerOffset.x, dy: centerOffset.y))
            context.addLine(to: CGPoint(x: CGFloat(i) * edge, y: bounds.maxY - edge * 13.0).offsetBy(dx: centerOffset.x, dy: centerOffset.y))
            context.strokePath()
            
            context.move(to: CGPoint(x: bounds.origin.x, y: bounds.maxY - CGFloat(i) * edge).offsetBy(dx: centerOffset.x, dy: centerOffset.y))
            context.addLine(to: CGPoint(x: edge * 13.0, y: bounds.maxY - CGFloat(i) * edge).offsetBy(dx: centerOffset.x, dy: centerOffset.y))
            context.strokePath()
            #elseif os(iOS)
            context.move(to: CGPoint(x: CGFloat(i) * edge, y: bounds.origin.y).offsetBy(dx: centerOffset.x, dy: centerOffset.y))
            context.addLine(to: CGPoint(x: CGFloat(i) * edge, y: edge * 13.0).offsetBy(dx: centerOffset.x, dy: centerOffset.y))
            context.strokePath()
            
            context.move(to: CGPoint(x: bounds.origin.x, y: CGFloat(i) * edge).offsetBy(dx: centerOffset.x, dy: centerOffset.y))
            context.addLine(to: CGPoint(x: edge * 13.0, y: CGFloat(i) * edge).offsetBy(dx: centerOffset.x, dy: centerOffset.y))
            context.strokePath()
            #endif
        }
        
        // Draw Labels
        
        let attributes = [
            NSAttributedString.Key.font : PlatformFont.systemFont(ofSize: fontSize, weight: .regular),
            NSAttributedString.Key.foregroundColor : theme.labelColor
        ]
        
        for i in 0...12 { for j in 0...12 {
            let index = i*13+j
            let text = HoldEm.StartingHands[index].string
            let textSize = text.size(withAttributes: attributes)
            
            #if os(macOS)
            let x = CGFloat(j) * edge + edge/2 - textSize.width/2
            let y = bounds.maxY - (CGFloat(i) * edge + edge/2 + textSize.height/2)
            #elseif os(iOS)
            let x = CGFloat(j) * edge + edge/2 - textSize.width/2
            let y = CGFloat(i) * edge + edge/2 - textSize.height/2
            #endif
            
            let textFrame = CGRect(x: x, y: y, width: textSize.width, height: textSize.height).offsetBy(dx: centerOffset.x, dy: centerOffset.y)
            text.draw(in: textFrame, withAttributes: attributes)
        }}
    }
    
    /// Bounds for hand at index of StartingHands
    
    private func bounds(for hand: Int) -> CGRect {
        let j = hand % 13
        let i = hand / 13
        
        #if os(macOS)
        let x = CGFloat(j) * edge
        let y = bounds.maxY - CGFloat(i) * edge - edge
        #elseif os(iOS)
        let x = CGFloat(j) * edge
        let y = CGFloat(i) * edge
        #endif
        
        return CGRect(x: x, y: y, width: edge, height: edge).offsetBy(dx: centerOffset.x, dy: centerOffset.y)
    }
    
    /// Bounds for string representation of hand
    
    private func bounds(for hand: UntypedHand) -> CGRect {
        if let index = HoldEm.StartingHands.firstIndex(of: hand) {
            return bounds(for: index)
        } else {
            return .zero
        }
    }
    
    /// Hand given a point in the view, may be null
    
    private func hand(for point: CGPoint) -> UntypedHand? {
        let offsetPoint = point.offsetBy(dx: -centerOffset.x, dy: -centerOffset.y)
        
        #if os(macOS)
        let i = Int((bounds.maxY-offsetPoint.y) / edge)
        let j = Int(offsetPoint.x / edge)
        #elseif os(iOS)
        let i = Int(offsetPoint.y / edge)
        let j = Int(offsetPoint.x / edge)
        #endif
        
        guard offsetPoint.x >= 0 && offsetPoint.y >= 0 else {
            return nil
        }
        
        guard offsetPoint.x <= bounds.width && offsetPoint.y <= bounds.height else {
            return nil
        }
        
        guard i < 13, j < 13 else {
            return nil
        }
        
        let index = i*13+j
        
        guard index < HoldEm.StartingHands.count else {
            return nil
        }
        
        return HoldEm.StartingHands[index]
    }
    
    private func maybeInverting(color: PlatformColor, for distribution: UntypedHand.Distribution) -> PlatformColor {
        #if os(macOS)
        if indicatesInvalidDistribution && !distribution.isValid {
            return color.usingColorSpace(.displayP3)!.inverted
        } else {
            return color
        }
        #elseif os(iOS)
        return color
        #endif
    }
    
    public func setNeedsDisplayForHand(_ hand: UntypedHand) {
        setNeedsDisplay(bounds(for: hand))
    }
}

#if os(macOS)

// MARK: - Mouse Events

extension RangeView {
    
    public override func mouseDown(with event: NSEvent) {
        let location = convert(event.locationInWindow, from: nil)
        guard let theHand = hand(for: location) else {
            return
        }
        
        delegate?.didBeginPainting(self, hand: theHand, flags: eventFlags(dragging: false))
        delegate?.didPaint(self, hand: theHand, flags: eventFlags(dragging: false))
        setNeedsDisplay(bounds(for: theHand))
    }
    
    public override func mouseDragged(with event: NSEvent) {
        let location = convert(event.locationInWindow, from: nil)
        guard let theHand = hand(for: location) else {
            return
        }
        
        delegate?.didPaint(self, hand: theHand, flags: eventFlags(dragging: true))
        setNeedsDisplay(bounds(for: theHand))
    }
    
    public override func mouseUp(with event: NSEvent) {
        delegate?.didFinishPainting(self, hand: nil, flags: eventFlags(dragging: false))
    }
    
    private func eventFlags(dragging: Bool) -> PaintFlags {
        if dragging {
            return [cmdKeyFlag, shiftKeyFlag, .dragging]
        } else {
            return [cmdKeyFlag, shiftKeyFlag]
        }
    }
    
    private var shiftKeyFlag: PaintFlags {
        return shiftKeyDown ? [.shiftKeyDown] : []
    }
    
    private var shiftKeyDown: Bool {
        return NSEvent.modifierFlags.contains(.shift)
    }
    
    private var cmdKeyFlag: PaintFlags {
        return cmdKeyDown ? [.cmdKeyDown] : []
    }
    
    private var cmdKeyDown: Bool {
        return NSEvent.modifierFlags.contains(.command)
    }
}

#endif

// MARK: - CGPoint Extension

fileprivate extension CGPoint {
    func offsetBy<T: BinaryFloatingPoint>(dx: T, dy: T) -> CGPoint {
        return CGPoint(x: self.x + CGFloat(dx), y: self.y + CGFloat(dy))
    }
}

// MARK: - Color Extension

fileprivate extension PlatformColor {
    var inverted: PlatformColor {
        var a: CGFloat = 0.0, r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return PlatformColor(red: 1.0-r, green: 1.0-g, blue: 1.0-b, alpha: a)
    }
}
