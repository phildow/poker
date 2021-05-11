//
//  PlayingCard.swift
//  
//
//  Created by Philip Dow on 5/11/21.
//

import Foundation

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
    
    /// Initializes a `PlayingCard` from a typed string description of a card such as Ah or Kd
    
    internal init(card: String) {
        let v = String(card[card.index(card.startIndex, offsetBy: 0)])
        let s = String(card[card.index(card.startIndex, offsetBy: 1)])
        self.init(value: Value(rawValue: v)!, suit: Suit(rawValue: s)!)
    }
}
