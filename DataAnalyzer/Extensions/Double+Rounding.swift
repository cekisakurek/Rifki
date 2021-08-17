//
//  Double+Rounding.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 29.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func roundedUp(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        
        return (self * divisor).rounded(.up) / divisor
    }
    
    func roundedDown(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        
        return (self * divisor).rounded(.down) / divisor
    }
    
    func string(fractionDigits:Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
