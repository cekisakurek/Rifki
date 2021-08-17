//
//  HistogramCalculator.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 06.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import Foundation
import SigmaSwiftStatistics
import Charts

struct HistorgramResult {
    var histogramEntries: [BarChartDataEntry]
    var frequencies: [ChartDataEntry]
    var normal: [ChartDataEntry]
    var width: Double
    
    var p: Double = 0.0
    var w: Double = 0.0
    var alpha: Double = 0.05
    var isGaussian = false
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

class HistogramCalculator: Operation {
    
    private(set) var identifier: String!
    
    private(set) var data: [Double]!
    private(set) var result: HistorgramResult?
    
    init(data: [Double], identifier: String) {
        
        self.identifier = identifier
        self.data = data
    }
    
    override func main() {
        
        if isCancelled {
            return
        }
        
        guard var data = data else { return }
        
        if isCancelled {
            return
        }
        
        if !data.isEmpty {
          
            data.prepare()
            let (frequencies, maxValue, minValue) = data.frequencies()
            
            let n = Double(data.count)
//            let maxValue = data.maxValue()
//            let minValue = data.minValue()
            
            let q3 = Sigma.percentile(data, percentile: 0.75)!
            let q1 = Sigma.percentile(data, percentile: 0.25)!
            
            let irq = q3 - q1
            var h =  2 * irq * pow(n, -1.0/3.0)
            
            if h == 0 {
                h = log2(n) + 1
            }
            
            var binSize = max(Int(round((maxValue - minValue) / h)),1)
            
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
            
            var set = HistorgramResult(histogramEntries: histogramEntries, frequencies: frequency, normal: normal, width: Double(h))
            
            if let (w, p) = calcSwilk(data: data) {
                set.w = w
                set.p = p
                
                if p > set.alpha {
                    set.isGaussian = true
//                    print("Sample looks Gaussian (fail to reject H0)")
                    
                }
                else {
                    set.isGaussian = false
//                    print("Sample does not look Gaussian (reject H0)")
                }
            }
            self.result = set
        }
    }
    
    func calcSwilk(data: [Double]) -> (Double, Double)? {
        let arr = data.sorted()
        
        let (w, p, error) = Rifki.swilk(x: arr)
        
        if error == .noError {
            return (w, p)
        }
        return nil
    }
    
    func calculateNormalFrequency(from data: [Double]) -> [ChartDataEntry] {
        
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
    
    func calculateFrequency(from array: [Double: Double]) -> [ChartDataEntry] {
        
        let sortedFreqKeys = array.keys.sorted()
        var entries = [ChartDataEntry]()
        for key in sortedFreqKeys {
            
            let value = array[key]!
            
            let entry = ChartDataEntry(x: Double(key), y: Double(value))
            
            entries.append(entry)
        }
        
        return entries
    }
    
    func calculateData(from binEdges: [BinEdge]) -> [BarChartDataEntry] {
        var histogramEntries = [BarChartDataEntry]()
        for edge in binEdges {
            
            let entry = BarChartDataEntry(x: Double((edge.leftValue + edge.rightValue)/2.0),
                                          y: Double(edge.itemCount))
            histogramEntries.append(entry)
        }
        return histogramEntries
    }
}
