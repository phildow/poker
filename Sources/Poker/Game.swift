//
//  Game.swift
//  
//
//  Created by Philip Dow on 5/11/21.
//

import Foundation

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
