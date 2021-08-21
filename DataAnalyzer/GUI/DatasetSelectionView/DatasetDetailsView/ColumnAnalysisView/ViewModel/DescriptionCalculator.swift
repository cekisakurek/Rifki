//
//  DescriptionCalculator.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 20.08.21.
//  Copyright © 2021 cekisakurek. All rights reserved.
//

import Foundation
import SigmaSwiftStatistics

struct DescriptionResult {
    var mean: String
    var std: String
    var min: String
    var twoFivePercentile: String
    var fiveZeroPercentile: String
    var sevenFivePercentile: String
    var max: String
    var kurtosis: String
    var skewness: String
    var type: String
    var swilkP: String
    var swilkW: String
    var isGaussian: String
}

final class DescriptionCalculator {
    
    static func calculate(column: ColumnAnalysis) -> DescriptionResult {
        let avg = String(format: "%.4f", column.average()!)
        let std = String(format: "%.4f", column.standardDeviationSample()!)
        let min = String(format: "%.4f", column.min()!)
        let twoFive = String(format: "%.4f", column.twoFive()!)
        let fiveZero = String(format: "%.4f", column.fiveZero()!)
        let sevenFive = String(format: "%.4f", column.sevenFive()!)
        let max = String(format: "%.4f", column.max()!)
        
        let skew = String(format: "%.4f", column.skewnessB()!)
        let kurt = String(format: "%.4f", column.kurtosisB()!)
        
        let type = column.type.rawValue
        
        var p = ""
        var w = ""
        var isGaussian = ""
        if let (wVal, pVal) = self.calcSwilk(data: column.dataAsDoubleArray()) {
            w = String(format: "%.4f", wVal)
            p = String(format: "%.4f", pVal)
            
            if pVal > 0.05 {
                isGaussian = NSLocalizedString("Yes", comment: "")
                
            }
            else {
                isGaussian = NSLocalizedString("No", comment: "")
            }
        }
        
        let result = DescriptionResult(mean: avg, std: std, min: min, twoFivePercentile: twoFive, fiveZeroPercentile: fiveZero, sevenFivePercentile: sevenFive, max: max, kurtosis: kurt, skewness: skew, type: type, swilkP: p, swilkW: w, isGaussian: isGaussian)
        return result
    }
    
    static func calcSwilk(data: [Double]) -> (Double, Double)? {
        let arr = data.sorted()
        
        let (w, p, error) = Rifki.swilk(x: arr)
        
        if error == .noError {
            return (w, p)
        }
        return nil
    }
    
}
