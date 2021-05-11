//
//  Hand.swift
//  
//
//  Created by Philip Dow on 5/11/21.
//

// TODO: Hands are specifically holdem hands

import Foundation

/// The suitedness of an untyped hand, whether it is suited or unsuited.

public enum Suited: String {
    case suited = "s"
    case offsuite = "o"
}

/// An untyped hand only indicates whether the hand is suited (s) or unsuited (o) without specifying the suits, such as "AKo". StartingHands are untyped.

public struct UntypedHand: Equatable {
    
    /// The string representation of the hand
    
    public let string: String
    
    /// Default initializer. String should be of format AKo, AKs, or AA. No error checking is performed
    
    public init(string: String) {
        self.string = string
    }
    
    /// Untyped hands are equal if the underlying string representations are equal
    
    public static func == (h1: Self, h2: Self) -> Bool {
        return h1.string == h2.string
    }
    
    /// Untyped hands are not equal if the underlying string representations are not equal
    
    public static func != (h1: Self, h2: Self) -> Bool {
        return h1.string != h2.string
    }
    
    /// Converts an UntypedHand to a TypedHand with randomly chosen suits
    
    public var typedHand: TypedHand {
        let v1 = String(string[string.index(string.startIndex, offsetBy: 0)])
        let v2 = String(string[string.index(string.startIndex, offsetBy: 1)])
        
        let s1 = PlayingCard.Suit.allCases.randomElement()!.rawValue
        var s2 = s1
        while s2 == s1 {
            s2 = PlayingCard.Suit.allCases.randomElement()!.rawValue
        }
        
        if string.count == 2 {
            // pocket pair
            return TypedHand(string: "\(v1)\(s1)\(v2)\(s2)")
        } else if String(string[string.index(string.startIndex, offsetBy: 2)]) == Suited.suited.rawValue {
            // suited cards
            return TypedHand(string: "\(v1)\(s1)\(v2)\(s1)")
        } else {
            // unsuited cards
            return TypedHand(string: "\(v1)\(s1)\(v2)\(s2)")
        }
    }
}

public extension UntypedHand {
    
    /// The distribution of actions to take with an untyped hand such as KK or AKs
    /// The exact meaning of raise will depend on the context: raise, 3bet, 4bet, etc
    
    struct Distribution {
        public var hand: UntypedHand
        public var raise: Double
        public var call: Double
        public var fold: Double
        public var notInRange: Double
        
        public init(hand: UntypedHand, raise: Double, call: Double, fold: Double, notInRange: Double) {
            self.hand = hand
            self.raise = raise
            self.call = call
            self.fold = fold
            self.notInRange = notInRange
        }
        
        public init(hand: String, raise: Double, call: Double, fold: Double, notInRange: Double) {
            self.init(hand: UntypedHand(string: hand), raise: raise, call: call, fold: fold, notInRange: notInRange)
        }
        
        /// Returns true if this is a valid probability distribution, false otherwise
        
        public var isValid: Bool {
            return sign == 1 && fabs(sum - 1) < Double.ulpOfOne
        }
        
        /// Returns -1 if any of raise, call, fold, or notInRange is negative, returns +1 otherwise
        
        private var sign: Int {
            return (fold < 0 || call < 0 || raise < 0 || notInRange < 0) ? -1 : 1
        }
        
        /// Returns the sum of raise, call, fold, and notInRange
        
        private var sum: Double {
            return fold + call + raise + notInRange
        }
    }
}

/// A typed hand is a fully specified hand with suits such as "AhKd".

public struct TypedHand: Equatable {
    
    /// The string representation of the hand
    
    public let string: String
    
    /// Default initializer. String should be of format AhKh. No error checking is performed
    
    public init(string: String) {
        self.string = string
    }
    
    /// Typed hands are equal if the underlying string representations are equal
    
    public static func == (h1: Self, h2: Self) -> Bool {
        return h1.string == h2.string
    }
    
    /// Typed hands are not equal if the underlying string representations are not equal
    
    public static func != (h1: Self, h2: Self) -> Bool {
        return h1.string != h2.string
    }
    
    /// Returns a tuple of `PlayingCard` for the hand
    
    public var playingCards: (PlayingCard, PlayingCard) {
        let c1 = String(string.prefix(2))
        let c2 = String(string.suffix(2))
        return (PlayingCard(card: c1), PlayingCard(card: c2))
    }
}

public extension TypedHand {
    
    /// The distribution of actions to take with a typed hand such as KcKd or AhKh
    /// The exact meaning of raise will depend on the context: raise, 3bet, 4bet, etc
    
    struct TypedDistribution {
        public var hand: TypedHand
        public var raise: Double
        public var call: Double
        public var fold: Double
        public var notInRange: Double
        
        public init(hand: TypedHand, raise: Double, call: Double, fold: Double, notInRange: Double) {
            self.hand = hand
            self.raise = raise
            self.call = call
            self.fold = fold
            self.notInRange = notInRange
        }
        
        public init(hand: String, raise: Double, call: Double, fold: Double, notInRange: Double) {
            self.init(hand: TypedHand(string: hand), raise: raise, call: call, fold: fold, notInRange: notInRange)
        }
        
        /// Returns true if this is a valid probability distribution, false otherwise
        
        public var isValid: Bool {
            return sign == 1 && fabs(sum - 1) < Double.ulpOfOne
        }
        
        /// Returns -1 if any of raise, call, fold, or notInRange is negative, returns +1 otherwise
        
        private var sign: Int {
            return (fold < 0 || call < 0 || raise < 0 || notInRange < 0) ? -1 : 1
        }
        
        /// Returns the sum of raise, call, fold, and notInRange
        
        private var sum: Double {
            return fold + call + raise + notInRange
        }
    }
}
