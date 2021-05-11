//
//  Poker.swift
//  Poker Swift Package
//
//  Created by Philip Dow on 5/5/21.
//

// TODO: Hands are specifically holdem hands
// TODO: method conflicts when we typealias TypedHand and UntypedHand to String, make proper class or struct

import Foundation

/// An untyped hand only indicates whether the hand is suited (s) or unsited (o) without specifying the suits, such as "AKo". StartingHands are untyped.

public typealias UntypedHand = String

/// A typed hand is a fully specified hand with suits such as "AhKd".

public typealias TypedHand = String

/// The suitedness of an untyped hand, whether it is suited or unsuited.

public enum Suited: String {
    case suited = "s"
    case offsuite = "o"
}

/// A playing card is a fully typed card with a suit and a value.

public struct PlayingCard {
    
    /// The suit of the playing card
    
    public enum Suit: String, CaseIterable {
        case hearts = "h"
        case spades = "s"
        case diamonds = "d"
        case clubs = "c"
        
        public var graphic: String {
            switch self {
            case .hearts:   return "♥"
            case .spades:   return "♠"
            case .diamonds: return "♦"
            case .clubs:    return "♣"
            }
        }
    }
    
    /// The value of the playing card
    
    public enum Value: String, CaseIterable {
        case deuce = "2"
        case trey = "3"
        case four = "4"
        case five = "5"
        case six = "6"
        case seven = "7"
        case eight = "8"
        case nine = "9"
        case ten = "T"
        case jack = "J"
        case queen = "Q"
        case king = "K"
        case ace = "A"
    }
    
    public let value: Value
    public let suit: Suit
    
    public init(value: Value, suit: Suit) {
        self.value = value
        self.suit = suit
    }
    
    fileprivate init(hand: TypedHand) {
        let v = String(hand[hand.index(hand.startIndex, offsetBy: 0)])
        let s = String(hand[hand.index(hand.startIndex, offsetBy: 1)])
        self.init(value: Value(rawValue: v)!, suit: Suit(rawValue: s)!)
    }
}

/// A table has players sitting in particular positions with action

public struct Table {

    /// The player under consideration is either the hero or the villain (opponent).

    public enum Player: String, CaseIterable {
        case hero
        case villain
    }

    /// The position at the table. Any player involved in a hand will have a position.

    public enum Position: String, CaseIterable {
        case SB
        case BB
        case UTG
        case UTG1 = "UTG+1"
        case LJ
        case HJ
        case CO
        case BTN
    }

    /// The action facing the hero. All actions but raise first in (RFI) imply a villain.

    public enum Action: String, CaseIterable {
        case LIMP
        case RFI
        case VS_RAISE
        case VS_3BET
        case VS_4BET
        case VS_5BET
        
        public func humanReadable() -> String {
            switch self {
            case .LIMP: return "Limp"
            case .RFI: return "RFI"
            case .VS_RAISE: return "VS Raise"
            case .VS_3BET: return "VS 3Bet"
            case .VS_4BET: return "VS 4Bet"
            case .VS_5BET: return "VS 5Bet"
            }
        }
    }
}

extension UntypedHand {
    
    /// The distribution of actions to take with an untyped hand such as KK or AKs
    /// The exact meaning of raise will depend on the context: raise, 3bet, 4bet, etc
    
    public struct Distribution {
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
    
    /// Converts an UntypedHand to a TypedHand with randomly chosen suits
    
    public var typeHand: TypedHand {
        let v1 = String(self[self.index(self.startIndex, offsetBy: 0)])
        let v2 = String(self[self.index(self.startIndex, offsetBy: 1)])
        
        let s1 = PlayingCard.Suit.allCases.randomElement()!.rawValue
        var s2 = s1
        while s2 == s1 {
            s2 = PlayingCard.Suit.allCases.randomElement()!.rawValue
        }
        
        if self.count == 2 {
            // pocket pair
            return "\(v1)\(s1)\(v2)\(s2)"
        } else if String(self[self.index(self.startIndex, offsetBy: 2)]) == Suited.suited.rawValue {
            // suited cards
            return "\(v1)\(s1)\(v2)\(s1)"
        } else {
            // unsuited cards
            return "\(v1)\(s1)\(v2)\(s2)"
        }
    }
    
}

extension TypedHand {
    
    /// The distribution of actions to take with a typed hand such as KcKd or AhKh
    /// The exact meaning of raise will depend on the context: raise, 3bet, 4bet, etc
    
    public struct TypedDistribution {
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
    
    /// Returns a tuple of `PlayingCard` for the hand
    
    public var playingCards: (PlayingCard, PlayingCard) {
        let c1 = String(self.prefix(2))
        let c2 = String(self.suffix(2))
        return (PlayingCard(hand: c1), PlayingCard(hand: c2))
    }
}

/// Information about the game

public struct Game {
    
    /// Whether the game is a cash game or tournament, with different implications for number of blinds and ranges
    
    public enum Structure: String {
        case cash
        case tournament
    }
    
    /// Variant of poker such as hold em, no limit hold em, or stud
    
    public enum Variant {
        case NLHE
    }
    
    /// Type of betting
    
    public enum Betting {
        case limit
        case noLimit
        case pot
    }
}

/// All possible untyped starting hands in hold'em.

public struct HoldEm {
    
    public static let StartingHands: [UntypedHand] = [
        "AA" , "AKs" , "AQs", "AJs", "ATs", "A9s", "A8s", "A7s", "A6s", "A5s", "A4s", "A3s", "A2s",
        "AKo" , "KK" , "KQs", "KJs", "KTs", "K9s", "K8s", "K7s", "K6s", "K5s", "K4s", "K3s", "K2s",
        "AQo" , "KQo" , "QQ", "QJs", "QTs", "Q9s", "Q8s", "Q7s", "Q6s", "Q5s", "Q4s", "Q3s", "Q2s",
        "AJo" , "KJo" , "QJo", "JJ", "JTs", "J9s", "J8s", "J7s", "J6s", "J5s", "J4s", "J3s", "J2s",
        "ATo" , "KTo" , "QTo", "JTo", "TT", "T9s", "T8s", "T7s", "T6s", "T5s", "T4s", "T3s", "T2s",
        "A9o" , "K9o" , "Q9o", "J9o", "T9o", "99", "98s", "97s", "96s", "95s", "94s", "93s", "92s",
        "A8o" , "K8o" , "Q8o", "J8o", "T8o", "98o", "88", "87s", "86s", "85s", "84s", "83s", "82s",
        "A7o" , "K7o" , "Q7o", "J7o", "T7o", "97o", "87o", "77", "76s", "75s", "74s", "73s", "72s",
        "A6o" , "K6o" , "Q6o", "J6o", "T6o", "96o", "86o", "76o", "66", "65s", "64s", "63s", "62s",
        "A5o" , "K5o" , "Q5o", "J5o", "T5o", "95o", "85o", "75o", "65o", "55", "54s", "53s", "52s",
        "A4o" , "K4o" , "Q4o", "J4o", "T4o", "94o", "84o", "74o", "64o", "54o", "44", "43s", "42s",
        "A3o" , "K3o" , "Q3o", "J3o", "T3o", "93o", "83o", "73o", "63o", "53o", "43o", "33", "32s",
        "A2o" , "K2o" , "Q2o", "J2o", "T2o", "92o", "82o", "72o", "62o", "52o", "42o", "32o", "22",
    ]

}
