//
//  Poker.swift
//  Poker Swift Package
//
//  Created by Philip Dow on 5/5/21.
//

import Foundation

/// An untyped hand only indicates whether the hand is suited (s) or unsited (o) without specifying the suits, such as "AKo". StartingHands are untyped.

typealias UntypedHand = String

/// A typed hand is a fully specified hand with suits such as "AhKd".

typealias TypedHand = String

/// The suitedness of an untyped hand, whether it is suited or unsuited.

enum Suited: String {
    case suited = "s"
    case offsuite = "o"
}

/// A playing card is a fully typed card with a suit and a value.

struct PlayingCard {
    enum Suit: String, CaseIterable {
        case hearts = "♥"
        case spades = "♠"
        case diamonds = "♦"
        case clubs = "♣"
    }
    enum Value: String, CaseIterable {
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
    
    let suit: Suit
    let value: Value
}

/// A table has players sitting in particular positions with action

struct Table {

    /// The player under consideration is either the hero or the villain (opponent).

    enum Player: String, CaseIterable {
        case hero
        case villain
    }

    /// The position at the table. Any player involved in a hand will have a position.

    enum Position: String, CaseIterable {
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

    enum Action: String, CaseIterable {
        case LIMP
        case RFI
        case VS_RAISE
        case VS_3BET
        case VS_4BET
        case VS_5BET
        
        func humanReadable() -> String {
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

/// The distribution of actions to take with an untyped hand.
/// Raise may simply mean raise but may also mean 3bet, 4bet, 5bet, etc depending on the context.

struct ActionDistribution {
    var hand: UntypedHand
    var raise: Float
    var call: Float
    var fold: Float
    var notInRange: Float
}

/// Whether the game is a cash game or tournament, with different implications for number of blinds and ranges

enum GameType: String {
    case cash
    case tournament
}

/// All the information needed to specify a set of drills, including metadata about the game, the players' positions and action,
/// and whether the positions and action can be changed.
///
/// A specific drill will generate a random untyped hand for the hero, type it to suits,
/// and then look up the `ActionDistribution` for that hand given the other parameters of the drill.

struct Drill {
    let title: String
    let gameType: GameType
    let blinds: Int
    let hero: [Table.Position]
    let villain: [Table.Position]
    let action: [Table.Action]
    let heroLocked: Bool
    let villainLocked: Bool
    let actionLocked: Bool
}

/// All possible untyped starting hands in hold'em.

struct HoldEm {
    
    static let StartingHands: [UntypedHand] = [
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
