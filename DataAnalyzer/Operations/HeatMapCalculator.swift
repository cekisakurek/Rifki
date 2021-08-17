//
//  HeatMapCalculator.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 10.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import Foundation
import SigmaSwiftStatistics

struct HeatMapResult {
    var labels: [String]
    var matrix: [[Double]]
}

class HeatMapCalculator: Operation {
    
    private(set) var identifier: String!
    private(set) var dataset: GraphRawData!
    
    private(set) var result: HeatMapResult?
    
    init(dataset: GraphRawData, identifier: String) {
        
        self.identifier = identifier
        self.dataset = dataset
    }
    
    override func main() {
    
        if isCancelled {
            return
        }
        
        var labels = [String]()
        for i in 0..<dataset.headers!.count {
            
            let type = dataset.typeOfColumn(columnIndex: i)
            if type == .Number {
                labels.append(dataset.headers![i])
            }
        }
        
        let hCount = Int(labels.count)
        var corr = [[Double]](repeating: [0.0], count: hCount)
        
        var minValue = Double.greatestFiniteMagnitude
        var maxValue = 0.0
        
        for (columnIndex, columnName) in labels.enumerated() {
            var rowCorr = [Double](repeating: 0.0, count: labels.count)
            let (columnValues, _) = dataset!.column(named: columnName)

            for (rowIndex, rowName) in labels.enumerated() {
                let (rowValues, _) = dataset!.column(named: rowName)

                var c = 0.0
                if columnIndex == rowIndex {
                    c = 1.0
                }
                else {
                    c = Sigma.pearson(x: rowValues as! [Double], y: columnValues as! [Double]) ?? 0
                    c = c.roundedUp(toPlaces: 4)
                }

                if c < minValue  {
                    minValue = c
                }
                if c > maxValue {
                    maxValue = c
                }
                rowCorr[rowIndex] = c

            }
            corr[columnIndex] = rowCorr
        }
        
        let result = HeatMapResult(labels: labels, matrix: corr)
        self.result = result
    }
}
