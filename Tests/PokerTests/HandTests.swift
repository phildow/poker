    import XCTest
    @testable import Poker

    final class HandTests: XCTestCase {
        
        // Untyped Hands
        
        func testSuitedUntypedHandToTypedHand() {
            let untypedHand = UntypedHand(string: "AKs")
            let typedHand = untypedHand.typedHand
            
            let v1 = String(typedHand.string[typedHand.string.index(typedHand.string.startIndex, offsetBy: 0)])
            let s1 = String(typedHand.string[typedHand.string.index(typedHand.string.startIndex, offsetBy: 1)])
            let v2 = String(typedHand.string[typedHand.string.index(typedHand.string.startIndex, offsetBy: 2)])
            let s2 = String(typedHand.string[typedHand.string.index(typedHand.string.startIndex, offsetBy: 3)])
            
            XCTAssert(typedHand.string.count == 4)
            XCTAssert(v1 == "A")
            XCTAssert(v2 == "K")
            XCTAssert(s1 == s2)
        }
        
        func testOffsuitUntypedHandToTypedHand() {
            let untypedHand = UntypedHand(string: "AKo")
            let typedHand = untypedHand.typedHand
            
            let v1 = String(typedHand.string[typedHand.string.index(typedHand.string.startIndex, offsetBy: 0)])
            let s1 = String(typedHand.string[typedHand.string.index(typedHand.string.startIndex, offsetBy: 1)])
            let v2 = String(typedHand.string[typedHand.string.index(typedHand.string.startIndex, offsetBy: 2)])
            let s2 = String(typedHand.string[typedHand.string.index(typedHand.string.startIndex, offsetBy: 3)])
            
            XCTAssert(typedHand.string.count == 4)
            XCTAssert(v1 == "A")
            XCTAssert(v2 == "K")
            XCTAssert(s1 != s2)
        }
        
        func testPairedUntypedHandToTypedHand() {
            let untypedHand = UntypedHand(string: "88")
            let typedHand = untypedHand.typedHand
            
            let v1 = String(typedHand.string[typedHand.string.index(typedHand.string.startIndex, offsetBy: 0)])
            let s1 = String(typedHand.string[typedHand.string.index(typedHand.string.startIndex, offsetBy: 1)])
            let v2 = String(typedHand.string[typedHand.string.index(typedHand.string.startIndex, offsetBy: 2)])
            let s2 = String(typedHand.string[typedHand.string.index(typedHand.string.startIndex, offsetBy: 3)])
            
            XCTAssert(typedHand.string.count == 4)
            XCTAssert(v1 == "8")
            XCTAssert(v2 == "8")
            XCTAssert(s1 != s2)
        }
        
        // Typed Hands
         
        func testSuitedTypedHandToPlayingCards() {
            let typedHand = TypedHand(string: "AhKh")
            let (c1,c2) = typedHand.playingCards
            
            XCTAssert(c1.value.rawValue == "A")
            XCTAssert(c1.suit.rawValue == "h")
            XCTAssert(c2.value.rawValue == "K")
            XCTAssert(c2.suit.rawValue == "h")
        }
        
        func testOffsuitTypedHandToPlayingCards() {
            let typedHand = TypedHand(string: "AhKd")
            let (c1,c2) = typedHand.playingCards
            
            XCTAssert(c1.value.rawValue == "A")
            XCTAssert(c1.suit.rawValue == "h")
            XCTAssert(c2.value.rawValue == "K")
            XCTAssert(c2.suit.rawValue == "d")
        }
        
        func testPairedTypedHandToPlayingCards() {
            let typedHand = TypedHand(string: "8h8d")
            let (c1,c2) = typedHand.playingCards
            
            XCTAssert(c1.value.rawValue == "8")
            XCTAssert(c1.suit.rawValue == "h")
            XCTAssert(c2.value.rawValue == "8")
            XCTAssert(c2.suit.rawValue == "d")
        }
        
        // 
    }
