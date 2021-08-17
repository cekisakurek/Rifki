//
//  ProbabilityDataCalculator.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 07.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import Foundation
import Charts

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

struct ProbabilityResult {
    var probabilities: [ChartDataEntry]
    var normal: [ChartDataEntry]
}

class ProbabilityDataCalculator: Operation {
    
    private(set) var identifier: String!
    
    private(set) var data: [Double]!
    private(set) var result: ProbabilityResult?
    
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
            
            
            let dataSet = ProbabilityResult(probabilities: probabilities, normal: normalEntries)
            self.result = dataSet
        }
    }
}
