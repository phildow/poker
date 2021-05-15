//
//  File.swift
//  
//
//  Created by Philip Dow on 5/15/21.
//

import Foundation

extension Double {
    
    /// Double safe equality test
    
    static func equals(lhs: Double, rhs: Double) -> Bool {
        return fabs(lhs - rhs) < Double.ulpOfOne
    }
    
    /// Double safe zero test
    
    static func isZero(double: Double) -> Bool {
        return equals(lhs: double, rhs: 0)
    }
    
    /// Rounds the double value to the specified number of places
    
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded(.toNearestOrEven) / divisor
    }
}
