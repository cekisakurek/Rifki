//
//  ProbabilityDataCalculator.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 07.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import Foundation

import SigmaSwiftStatistics

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
        //            print(n)
        dist.append([n,sortedData[i]])
        
        
    }
    
    
    return dist
}

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

class ProbabilityDataCalculator: Operation {
    
    private(set) var identifier: String!
    
    private(set) var data: [Double]!
    private(set) var result: ProbabilityPlotDataSet?
    
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
          
            
            let distribution = probabilityDistrubition(data: data)
            
            var dataPoints = [BarDataPoint]()
            
            for item in distribution {
                
                let xPoint = PointDoubleValue(value: item[0], label: "Theoretical Quantiles")
                let yPoint = PointDoubleValue(value: item[1], label: "Ordered Values")
                let point = BarDataPoint(x: xPoint, y: yPoint)
                dataPoints.append(point)
            }
            
            
            let (b,m) = lsr(distribution)

            var normalPoints = [BarDataPoint]()
            
            for p in distribution {
                let x = p[0]
                let y = (m * x) + b
                let xPoint = PointDoubleValue(value: x, label: "Theoretical Quantiles")
                let yPoint = PointDoubleValue(value: y, label: "Ordered Values")
                let point = BarDataPoint(x: xPoint, y: yPoint)
                normalPoints.append(point)
                
            }
            
//            let x = c[0][0]
//            let y = (m*x) + b
            
            
            
            
            let dataSet = ProbabilityPlotDataSet(points: dataPoints, normal: normalPoints)
            self.result = dataSet
            
            
            
            

            
            
            
            
            
//            let (_, maxFreq, _) = data.frequencies()
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
//            let binSize = max(Int(round((maxValue - minValue) / h)),1)
//
//            var bins = [Int: Int]()
//            let sortedData = data.sorted()
//
//
//            for i in 0..<binSize {
//                bins[i] = 0
//                for value in sortedData {
//
//                    if value >= minValue + (h * Double(i)) && value < (minValue + h) + h * Double(i) {
//                        bins[i]! += 1
//                    }
//                }
//            }
//
//            let sortedKeys = bins.keys.sorted()
//            var dataPoints = [BarDataPoint]()
//
//            var total = 0
//            for key in sortedKeys {
//                let count = bins[key]!
//                print(count)
//                total += count
//                let xPoint = PointDoubleValue(value: Double(key), label: "bin")
//                let yPoint = PointDoubleValue(value: Double(count), label: "Freq")
//                let point = BarDataPoint(x: xPoint, y: yPoint)
//                dataPoints.append(point)
//
//            }
//
//
//            let dataSet = BarDataSet(points: dataPoints, maxXValue: maxValue, maxYValue: maxFreq)
//
//            self.result = dataSet
        }
    }
    

}
