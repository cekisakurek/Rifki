//
//  Math.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 20.08.21.
//  Copyright © 2021 cekisakurek. All rights reserved.
//

import Foundation
import SigmaSwiftStatistics

func lsr(_ points: [[Double]]) -> (Double, Double) {
    var total_x = 0.0
    var total_xy = 0.0
    var total_y = 0.0
    var total_x2 = 0.0
    for i in 0..<points.count {
        total_x += points[i][0]
        total_y += points[i][1]
        total_xy += points[i][0]*points[i][1]
        total_x2 += pow(points[i][0], 2)
    }
    let N = Double(points.count)
    let m = (N*total_xy - total_x*total_y)/(N*total_x2 - pow(total_x, 2))
    let b = (total_y - m*total_x)/N
    return (b, m)
}

func probabilityDistrubition(data: [Double]) -> [[Double]] {
    
    var dist = [[Double]]()
    
    let sortedData = data.sorted()
    
    let n = Double(data.count)
    for i in 0..<data.count {
        var q = 0.0
        if i == 0 {
            q = 1.0 - Double(pow(0.5, 1.0/n))
        }
        else if i == data.count - 1 {
            q = Double(pow(0.5, 1.0/n))
        }
        else {
            q = (Double(i) - 0.3175) / (n + 0.365)
        }
        let n = Sigma.normalQuantile(p: q, μ: 0, σ: 1)!
        dist.append([n,sortedData[i]])
    }
    return dist
}

extension Array where Element == Double {
    
    func frequencies() -> ([Double: Double], Double, Double) {
        
        var freq = [Double:Double]()
        let kernel = KernelDensityEstimation(self)!
        
        var min = Double.greatestFiniteMagnitude
        var max = 0.0
        
        for p in self {
            
            let density = kernel.evaluate(p)
            if p > max {
                max = p
            }
            if p < min {
                min = p
            }
            freq[p] = density

        }
        return (freq, max, min)
    }
    
    func minValue() -> Double {

        var minX: Double = Double.greatestFiniteMagnitude
        for i in self {
            if i < minX {
                minX = i
            }
        }
        return minX
    }
    
    func maxValue() -> Double {

        var maxX: Double = 0.0
        for i in self {
            if i > maxX {
                maxX = i
            }
        }
        return maxX
    }
    
    func normalized() -> [Double] {
        var result = [Double]()
        let max = self.maxValue()
        let min = self.minValue()
        for i in self {
            let new = (i - min) / (max - min)
            result.append(new)
        }
        return result
    }
    
}

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

extension String {
    func isValidDouble(maxDecimalPlaces: Int) -> Bool {
        // Use NumberFormatter to check if we can turn the string into a number
        // and to get the locale specific decimal separator.
        let formatter = NumberFormatter()
        
        formatter.allowsFloats = true // Default is true, be explicit anyways
        let decimalSeparator = "."// formatter.decimalSeparator ?? "."  // Gets the locale specific decimal separator. If for some reason there is none we assume "." is used as separator.
        formatter.decimalSeparator = decimalSeparator
        // Check if we can create a valid number. (The formatter creates a NSNumber, but
        // every NSNumber is a valid double, so we're good!)
        if formatter.number(from: self) != nil {
            // Split our string at the decimal separator
            let split = self.components(separatedBy: decimalSeparator)
            
            // Depending on whether there was a decimalSeparator we may have one
            // or two parts now. If it is two then the second part is the one after
            // the separator, aka the digits we care about.
            // If there was no separator then the user hasn't entered a decimal
            // number yet and we treat the string as empty, succeeding the check
            let digits = split.count == 2 ? split.last ?? "" : ""
            
            // Finally check if we're <= the allowed digits
            return digits.count <= maxDecimalPlaces    // TODO: Swift 4.0 replace with digits.count, YAY!
        }
        
        return false // couldn't turn string into a valid number
    }
}
