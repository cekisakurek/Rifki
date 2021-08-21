//
//  ProbabilityCalculator.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 20.08.21.
//  Copyright © 2021 cekisakurek. All rights reserved.
//

import Foundation
import Charts

struct ProbabilityResult {
    var probabilities: [ChartDataEntry]
    var normal: [ChartDataEntry]
}

final class ProbabilityCalculator {
    
    static func calculate (column: ColumnAnalysis) -> ProbabilityResult {
        
        let data = column.dataAsDoubleArray()
        let distribution = probabilityDistrubition(data: data)
        
        var probabilities = [ChartDataEntry]()
        for item in distribution {
            let entry = ChartDataEntry(x: item[0], y: item[1])
            probabilities.append(entry)
        }
        
        let (b,m) = lsr(distribution)
        
        var normalEntries = [ChartDataEntry]()
        for p in distribution {
            let x = p[0]
            let y = (m * x) + b
            let entry = ChartDataEntry(x: x, y: y)
            normalEntries.append(entry)
        }
        
        
        return ProbabilityResult(probabilities: probabilities, normal: normalEntries)
    }
}
