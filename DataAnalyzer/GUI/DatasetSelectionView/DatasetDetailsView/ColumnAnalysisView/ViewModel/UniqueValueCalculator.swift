//
//  UniqueValueCalculator.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 20.08.21.
//  Copyright © 2021 cekisakurek. All rights reserved.
//

import Foundation
import Charts

struct UniqueValueResult {
    var count: [BarChartDataEntry]
    var keys: [String]
}

final class UniqueValueCalculator {
    
    static func calculate(column: ColumnAnalysis) -> UniqueValueResult {
        var unique = [String: Int]()
        
        for item in column.dataAsStringArray() {
            if let _ = unique[item] {
                unique[item]! += 1
            }
            else {
                unique[item] = 0
            }
        }
        var chartDataEntry = [BarChartDataEntry]()
        
        for (index, key) in unique.keys.sorted().enumerated() {
            let item = unique[key]
            let value = BarChartDataEntry(x: Double(index), y: Double(item!))
            chartDataEntry.append(value)
        }
        
        return UniqueValueResult(count: chartDataEntry, keys: Array(unique.keys.sorted()))
    }
}
