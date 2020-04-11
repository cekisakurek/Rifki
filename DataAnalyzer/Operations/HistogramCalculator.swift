//
//  HistogramCalculator.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 06.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import Foundation
import SigmaSwiftStatistics

class HistogramCalculator: Operation {
    
    private(set) var identifier: String!
    
    private(set) var data: [Double]!
    private(set) var result: BarDataSet?
    
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

            
            
//            let sortedKeys = bins.keys.sorted()
            
            
//            var total = 0
//            for key in sortedKeys {
//                let count = bins[key]!
//
//                total += count
//                let xPoint = PointDoubleValue(value: Double(key), label: "bin")
//                let yPoint = PointDoubleValue(value: Double(count), label: "Freq")
//                let point = BarDataPoint(x: xPoint, y: yPoint)
//                dataPoints.append(point)
//
//            }
            
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
            
//            let zeroEdge = BinEdge(leftValue: 0, rightValue: minValue, values: nil)
//            let maxEdge = BinEdge(leftValue: maxValue, rightValue: maxValue + h, values: nil)
//            binEdges.insert(zeroEdge, at: 0)
//            binEdges.append(maxEdge)
            
            
            var dataPoints = [BarDataPoint]()
            for edge in binEdges {
                
                let xPoint = PointDoubleValue(value: Double((edge.leftValue + edge.rightValue)/2.0), label: "bin")
                let yPoint = PointDoubleValue(value: Double(edge.values?.count ?? 0), label: "Freq")
                let point = BarDataPoint(x: xPoint, y: yPoint)
                dataPoints.append(point)
            }
            
            
            var freqPoints = [BarDataPoint]()
            
            let sortedFreqKeys = frequencies.keys.sorted()
            
            for key in sortedFreqKeys {
                
                let value = frequencies[key]!
                let xPoint = PointDoubleValue(value: Double(key), label: "bin")
                let yPoint = PointDoubleValue(value: Double(value), label: "Freq")
                let point = BarDataPoint(x: xPoint, y: yPoint)
                freqPoints.append(point)

            }
            

            let distribution = probabilityDistrubition(data: data)
            let (b,m) = lsr(distribution)
            
            
            var asd = [Double]()
            for p in distribution {
                let x = p[0]
                let y = (m * x) + b
                asd.append(y)
                
            }
            
            let (normalFrequencies, _, _) = asd.frequencies()
            
            var normalPoints = [BarDataPoint]()
            let sortedNormalFreqKeys = normalFrequencies.keys.sorted()
            for key in sortedNormalFreqKeys {
                
                let value = normalFrequencies[key]!
                let xPoint = PointDoubleValue(value: Double(key), label: "bin")
                let yPoint = PointDoubleValue(value: Double(value), label: "Freq")
                let point = BarDataPoint(x: xPoint, y: yPoint)
                normalPoints.append(point)
            }
            
            
            
            
            let dataSet = BarDataSet(points: dataPoints, maxXValue: maxValue, maxYValue: maxFreq, width: Double(h), frequencies: freqPoints, normalFrequencies: normalPoints)
            
            self.result = dataSet
           
            
            
            
//            let (_, maxFreq, _) = data.frequencies()
//

//
//            let normalized = data.normalized()
//
//            let trimmed = normalized.trimed(fromDigit: 4)
//            let hist = trimmed.histogram()
//
//            let min = data.minValue()
//            let max = data.maxValue()
//
//

//
////            let lastElement = (Double(nearest) - min) / (max - min)
////
////            hist[Double(lastElement)] = 0
//
//
//            let sortedKeys = hist.keys.sorted()
//
//            var dataPoints = [BarDataPoint]()
//
//            for key in sortedKeys {
//                let freq = Double(hist[key]!)
//                let nonNormalizedKey = Int(key * (max - min) + min)
//                let xPoint = PointDoubleValue(value: key, label: String(nonNormalizedKey))
//                let yPoint = PointDoubleValue(value: freq, label: String(freq))
//                let point = BarDataPoint(x: xPoint, y: yPoint)
//                dataPoints.append(point)
//
//            }
//
//

//
//            self.result = BarDataSet(points: dataPoints, xLabels: xlabels, yLabels: yLabels)
          
        }
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
