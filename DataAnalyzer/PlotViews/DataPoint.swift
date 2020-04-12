//
//  DataPoint.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 01.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import Foundation

struct PointDoubleValue {
    var value: Double = 0.0
    var label: String?
}

//struct PointStringValue {
//    var value: String
//    var label: String
//}




struct BarDataPoint {
    
    var x: PointDoubleValue
    var y: PointDoubleValue
}

struct BarDataSet {
    var points: [BarDataPoint]
    
    var maxXValue: Double
    var maxYValue: Double
    
    var width: Double
    
    var frequencies: [BarDataPoint]
    var normalFrequencies: [BarDataPoint]
}


struct ProbabilityPlotDataSet {
    var points: [BarDataPoint]
    var normal: [BarDataPoint]
}


struct BarGroupDataPoint {
    
}


struct BinEdge {
    var leftValue: Double
    var rightValue: Double
    
    var values: [Double: Double]?
    
    func frequency() -> Double {
        
        var cumFreq = 0.0
        if let values = values {
            for (_, freq) in values {
                cumFreq += freq
            }
            cumFreq = cumFreq / Double(values.count)
        }
        return cumFreq;
    }
}

