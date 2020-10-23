//
//  DoubleRound.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 23/10/20.
//

import Foundation

extension Double {
    
    /// Rounds the double to decimal places value
    func round(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
