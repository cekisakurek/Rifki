//
//  HistogramCalculation.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 20.08.21.
//  Copyright © 2021 cekisakurek. All rights reserved.
//

import Foundation
import SigmaSwiftStatistics
import Charts

struct HistorgramResult {
    var histogramEntries: [BarChartDataEntry]
    var frequencies: [ChartDataEntry]
    var normal: [ChartDataEntry]
    var width: Double
}

struct BinEdge {
    var leftValue: Double
    var rightValue: Double
    var values: [Double: Double]?
    
    var itemCount = 0
    
    func frequency() -> Double? {
        var totalFreq = 0.0
        if let values = values {
            for (_, freq) in values {
                totalFreq += freq
            }
            let avgFreq = totalFreq / Double(values.count)
            return avgFreq
        }
        return nil;
    }
}

final class HistogramCalculator {
    
    static func calculate(column: ColumnAnalysis) -> HistorgramResult {
        
        let data = column.dataAsDoubleArray()
        
        let (frequencies, maxValue, minValue) = data.frequencies()
        
        let n = Double(data.count)
        
        let q3 = Sigma.percentile(data, percentile: 0.75)!
        let q1 = Sigma.percentile(data, percentile: 0.25)!
        
        let irq = q3 - q1
        var h =  2 * irq * pow(n, -1.0/3.0)
        
        if h == 0 {
            h = log2(n) + 1
        }
        
        var binSize = max(Int(round((maxValue - minValue) / h)), 1)
        
        if binSize > 100 {
            binSize = 100
        }
        var bins = [Int: Int]()
        let sortedData = data.sorted()
        
       
        for i in 0..<binSize {
            bins[i] = 0
            for value in sortedData {
                
                if value >= minValue + (h * Double(i)) && value < (minValue + h) + h * Double(i) {
                    bins[i]! += 1
                }
            }
        }
        
        var binEdges = [BinEdge]()
        for i in 0..<binSize {
            
            var edge = BinEdge(leftValue: minValue + (h * Double(i)), rightValue: (minValue + h) + h * Double(i))
            edge.values = [Double:Double]()


            for value in sortedData {
                if value >= edge.leftValue && value < edge.rightValue {
                    if edge.values![value] != nil {
                        edge.values![value]! += 1
                    }
                    else {
                        edge.values![value] = 1
                    }
                    edge.itemCount += 1
                }
            }
            binEdges.append(edge)
        }
        
        let histogramEntries = calculateData(from: binEdges)
        let frequency = calculateFrequency(from: frequencies)
        let normal = calculateNormalFrequency(from: data)
        
        let set = HistorgramResult(histogramEntries: histogramEntries, frequencies: frequency, normal: normal, width: Double(h))
        
        
        return set
    }
    
    static func calculateData(from binEdges: [BinEdge]) -> [BarChartDataEntry] {
        var histogramEntries = [BarChartDataEntry]()
        for edge in binEdges {
            
            let entry = BarChartDataEntry(x: Double((edge.leftValue + edge.rightValue)/2.0),
                                          y: Double(edge.itemCount))
            histogramEntries.append(entry)
        }
        return histogramEntries
    }
    
    static func calculateFrequency(from array: [Double: Double]) -> [ChartDataEntry] {
        
        let sortedFreqKeys = array.keys.sorted()
        var entries = [ChartDataEntry]()
        for key in sortedFreqKeys {
            
            let value = array[key]!
            
            let entry = ChartDataEntry(x: Double(key), y: Double(value))
            
            entries.append(entry)
        }
        
        return entries
    }
    
    static func calculateNormalFrequency(from data: [Double]) -> [ChartDataEntry] {
        
        let distribution = probabilityDistrubition(data: data)
        let (b,m) = lsr(distribution)
        
        
        var dist = [Double]()
        for p in distribution {
            let x = p[0]
            let y = (m * x) + b
            dist.append(y)
        }
        let (normalFrequencies, _, _) = dist.frequencies()
        
        var entries = [ChartDataEntry]()
        let sortedNormalFreqKeys = normalFrequencies.keys.sorted()
        for key in sortedNormalFreqKeys {
            
            let value = normalFrequencies[key]!
            
            let entry = ChartDataEntry(x: Double(key), y: Double(value))
            entries.append(entry)
        }
        return entries
        
    }
}
