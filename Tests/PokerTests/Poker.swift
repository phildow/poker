    import XCTest
    @testable import Poker

    final class PokerTests: XCTestCase {
        
        func testSuitedUntypedHandToTypedHand() {
            let untypedHand = "AKs"
            let typedHand = untypedHand.typeHand
            
            let v1 = String(typedHand[typedHand.index(typedHand.startIndex, offsetBy: 0)])
            let s1 = String(typedHand[typedHand.index(typedHand.startIndex, offsetBy: 1)])
            let v2 = String(typedHand[typedHand.index(typedHand.startIndex, offsetBy: 2)])
            let s2 = String(typedHand[typedHand.index(typedHand.startIndex, offsetBy: 3)])
            
            XCTAssert(typedHand.count == 4)
            XCTAssert(v1 == "A")
            XCTAssert(v2 == "K")
            XCTAssert(s1 == s2)
        }
        
        func testOffsuitUntypedHandToTypedHand() {
            let untypedHand = "AKo"
            let typedHand = untypedHand.typeHand
            
            let v1 = String(typedHand[typedHand.index(typedHand.startIndex, offsetBy: 0)])
            let s1 = String(typedHand[typedHand.index(typedHand.startIndex, offsetBy: 1)])
            let v2 = String(typedHand[typedHand.index(typedHand.startIndex, offsetBy: 2)])
            let s2 = String(typedHand[typedHand.index(typedHand.startIndex, offsetBy: 3)])
            
            XCTAssert(typedHand.count == 4)
            XCTAssert(v1 == "A")
            XCTAssert(v2 == "K")
            XCTAssert(s1 != s2)
        }
        
        func testPairedUntypedHandToTypedHand() {
            let untypedHand = "88"
            let typedHand = untypedHand.typeHand
            
            let v1 = String(typedHand[typedHand.index(typedHand.startIndex, offsetBy: 0)])
            let s1 = String(typedHand[typedHand.index(typedHand.startIndex, offsetBy: 1)])
            let v2 = String(typedHand[typedHand.index(typedHand.startIndex, offsetBy: 2)])
            let s2 = String(typedHand[typedHand.index(typedHand.startIndex, offsetBy: 3)])
            
            XCTAssert(typedHand.count == 4)
            XCTAssert(v1 == "8")
            XCTAssert(v2 == "8")
            XCTAssert(s1 != s2)
        }
        
        //
         
        func testSuitedTypedHandToPlayingCards() {
            let typedHand = "AhKh"
            let (c1,c2) = typedHand.playingCards
            
            XCTAssert(c1.value.rawValue == "A")
            XCTAssert(c1.suit.rawValue == "h")
            XCTAssert(c2.value.rawValue == "K")
            XCTAssert(c2.suit.rawValue == "h")
        }
        
        func testOffsuitTypedHandToPlayingCards() {
            let typedHand = "AhKd"
            let (c1,c2) = typedHand.playingCards
            
            XCTAssert(c1.value.rawValue == "A")
            XCTAssert(c1.suit.rawValue == "h")
            XCTAssert(c2.value.rawValue == "K")
            XCTAssert(c2.suit.rawValue == "d")
        }
        
        func testPairedTypedHandToPlayingCards() {
            let typedHand = "8h8d"
            let (c1,c2) = typedHand.playingCards
            
            XCTAssert(c1.value.rawValue == "8")
            XCTAssert(c1.suit.rawValue == "h")
            XCTAssert(c2.value.rawValue == "8")
            XCTAssert(c2.suit.rawValue == "d")
        }
        
        // 
    }
