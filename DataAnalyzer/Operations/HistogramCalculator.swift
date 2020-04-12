//
//  HistogramCalculator.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 06.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import Foundation
import SigmaSwiftStatistics


struct HistorgramResult {
    var histogramEntries: [BarChartDataEntry]
    var frequencies: [ChartDataEntry]
    var normal: [ChartDataEntry]
    var width: Double
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
        
        guard let data = data else { return }
        
        if isCancelled {
            return
        }
        
        if !data.isEmpty {
          
            let (frequencies, maxFreq, _) = data.frequencies()
            
            let n = Double(data.count)
            let maxValue = data.maxValue()
            let minValue = data.minValue()
            
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


                for (value, density) in frequencies {

                    if value >= edge.leftValue && value < edge.rightValue {
                        edge.values![value] = density
                    }
                }
                binEdges.append(edge)
            }

            
            
            
            
            
            
            let histogramEntries = calculateData(from: binEdges)
            let frequency = calculateFrequency(from: frequencies)
            let normal = calculateNormalFrequency(from: data)
            let set = HistorgramResult(histogramEntries: histogramEntries, frequencies: frequency, normal: normal, width: Double(h))
            
            self.result = set
            
//            let dataSet = BarDataSet(points: dataPoints, maxXValue: maxValue, maxYValue: maxFreq, width: Double(h), frequencies: freqPoints, normalFrequencies: normalPoints)
//
//
//            self.result = dataSet
//
            

          
        }
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
        
//        var normalPoints = [BarDataPoint]()
        var entries = [ChartDataEntry]()
        let sortedNormalFreqKeys = normalFrequencies.keys.sorted()
        for key in sortedNormalFreqKeys {
            
            let value = normalFrequencies[key]!
            
            let entry = ChartDataEntry(x: Double(key), y: Double(value))
            entries.append(entry)
//            let xPoint = PointDoubleValue(value: Double(key), label: "bin")
//            let yPoint = PointDoubleValue(value: Double(value), label: "Freq")
//            let point = BarDataPoint(x: xPoint, y: yPoint)
//            normalPoints.append(point)
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
                                          y: Double(edge.values?.count ?? 0))
            histogramEntries.append(entry)
            
            //                let xPoint = PointDoubleValue(value: Double((edge.leftValue + edge.rightValue)/2.0), label: "bin")
            //                let yPoint = PointDoubleValue(value: Double(edge.values?.count ?? 0), label: "Freq")
            //                let point = BarDataPoint(x: xPoint, y: yPoint)
            //                dataPoints.append(point)
        }
        return histogramEntries
    }
    
}


//     let (frequencies, maxFreq, _) = data.frequencies()
//
//            let n = Double(data.count)
//            let maxValue = data.maxValue()
//            let minValue = data.minValue()
//
//            let q3 = Sigma.percentile(data, percentile: 0.75)!
//            let q1 = Sigma.percentile(data, percentile: 0.25)!
//
//            let irq = q3 - q1
//            var h =  2 * irq * pow(n, -1.0/3.0)
//
//            if h == 0 {
//                h = log2(n) + 1
//            }
//
//            var binSize = max(Int(((maxValue - minValue) / h)),1)
////
////            if binSize > 100 {
////                binSize = 100
////            }
//
//
//            var binEdges = [BinEdge]()
//            for i in 0..<binSize {
//                var edge = BinEdge(leftValue: minValue + (h * Double(i)), rightValue: (minValue + h) + h * Double(i))
//                edge.values = [Double:Double]()
//
//
//                for (value, density) in frequencies {
//
//                    if value >= edge.leftValue && value < edge.rightValue {
//                        edge.values![value] = density
//                    }
//                }
//                binEdges.append(edge)
//            }
//
//            var dataPoints = [BarDataPoint]()
//
//            for (i, edge) in binEdges.enumerated() {
//
//                let xPoint = PointDoubleValue(value: Double(i), label: "bin")
//                let yPoint = PointDoubleValue(value: Double(edge.values?.count ?? 0), label: "Freq")
//                let point = BarDataPoint(x: xPoint, y: yPoint)
//                dataPoints.append(point)
//
//            }
//
//            let dataSet = BarDataSet(points: dataPoints, maxXValue: maxValue, maxYValue: maxFreq)
//
//            self.result = dataSet
//
