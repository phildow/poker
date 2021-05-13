//
//  Table.swift
//  
//
//  Created by Philip Dow on 5/11/21.
//

import Foundation

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
        case NA
        
        public func humanReadable() -> String {
            switch self {
            case .LIMP:     return "Limp"
            case .RFI:      return "RFI"
            case .VS_RAISE: return "VS Raise"
            case .VS_3BET:  return "VS 3Bet"
            case .VS_4BET:  return "VS 4Bet"
            case .VS_5BET:  return "VS 5Bet"
            case .NA:       return "NA"
            }
        }
    }
}
