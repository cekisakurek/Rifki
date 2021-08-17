//
//  Array+Extension.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 05.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import Foundation

//extension Array where Element: Hashable {
//    func histogram() -> [Element: Int] {
//        return self.reduce(into: [:]) { counts, elem in counts[elem, default: 0] += 1 }
//    }
//}

//extension Dictionary where Key == Double, Value == Int {
//    
//    func findMinAndMaxValue() -> (Int, Int) {
//     
//        var min = Int.max
//        var max = 0
//        
//        for (_, value) in self {
//            if value < min {
//                min = value
//            }
//            if value > max {
//                max = value
//            }
//            
//        }
//        return (min, max)
//    }
//    
////    func values() -> [Int] {
////        
////        var arr = [Int]()
////        for (_, value) in self {
////            arr.append(value)
////        }
////        return arr
////    }
//}

extension Array where Element == Double {
    
    func minValue() -> Double {
        
        var minX: Double = Double.greatestFiniteMagnitude
        for i in self {
            if i < minX {
                minX = i
            }
        }
        return minX
    }
    
    func maxValue() -> Double {
        
        var maxX: Double = 0.0
        for i in self {
            if i > maxX {
                maxX = i
            }
        }
        return maxX
    }
    
//    func normalized() -> [Double] {
//        var result = [Double]()
//        let max = self.maxValue()
//        let min = self.minValue()
//        for i in self {
//            let new = (i - min) / (max - min)
//            result.append(new)
//        }
//        return result
//    }
    
//    func trimed(fromDigit: Int) -> [Double] {
//
//        var trimmed = [Double]()
//        for value in self {
//
//            let trimmedValue = Double(round(Double(fromDigit * 10) * value) / Double(fromDigit * 10))
//            trimmed.append(trimmedValue)
//        }
//        return trimmed
//    }
    
    mutating func prepare() {
        self.removeAll(where: { $0 == 0.0 })
    }
    
    func frequencies() -> ([Double: Double], Double, Double) {
        
        var freq = [Double:Double]()
        let kernel = KernelDensityEstimation(self)!
        
        var min = Double.greatestFiniteMagnitude
        var max = 0.0
        
        for p in self {
            
            let density = kernel.evaluate(p)
            if p > max {
                max = p
            }
            if p < min {
                min = p
            }
            freq[p] = density

        }
        return (freq, max, min)
    }
    
//    func findMaxFrequency(data: [Double]) -> (Double, Double) {
//        
//        let kernel = KernelDensityEstimation(data)!
//        
//        
//        var minDensity = Double.greatestFiniteMagnitude
//        var maxDensity = 0.0
//        for p in data {
//            
//            let density = kernel.evaluate(p)
//            if density > maxDensity {
//                maxDensity = density
//            }
//            if density < minDensity {
//                minDensity = density
//            }
//        }
//        return (minDensity, maxDensity)
//    }
}

extension Array where Element == Double {
    
}

//extension Array where Element == BarDataPoint {
//    
//    func maxXValue() -> Double {
//        
//        var maxX: Double = 0.0
//        for point in self {
//            if point.x.value > maxX {
//                maxX = point.x.value
//            }
//        }
//        return maxX
//    }
//    
//    func minXValue() -> Double {
//        
//        var minX: Double = maxXValue()
//        for point in self {
//            if point.x.value < minX {
//                minX = point.x.value
//            }
//        }
//        return minX
//    }
//    
//    func maxYValue() -> Double {
//        
//        var maxY: Double = 0.0
//        for point in self {
//            if point.y.value > maxY {
//                maxY = point.y.value
//            }
//        }
//        return maxY
//    }
//    
//    func minYValue() -> Double {
//        
//        var minY: Double = Double.greatestFiniteMagnitude
//        for point in self {
//            if point.y.value < minY {
//                minY = point.y.value
//            }
//        }
//        return minY
//    }
//    
//}
