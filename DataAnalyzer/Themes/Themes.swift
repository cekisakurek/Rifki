//
//  DistributionGraphTheme.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 11.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit
import Combine
import SwiftUI


struct AppThemeKey: EnvironmentKey {
    static let defaultValue = AppTheme()
}

extension EnvironmentValues {
    var appTheme: AppTheme {
        get { return self[AppThemeKey] }
        set { self[AppThemeKey] = newValue }
    }
}

class AppTheme {
    
    private(set) var rawAnalysis = RawAnaysis()
    private(set) var columnAnalysis = ColumnAnalysis()
    private(set) var heatmap = Heatmap()
    private(set) var playground = Playground()
    
    class RawAnaysis {
        var rawDataCell1Background = UIColor.white
        var rawDataCell2Background = UIColor(red: CGFloat(210.0/255.0), green: CGFloat(210.0/255.0), blue: CGFloat(210.0/255.0), alpha: 1.0)
    }
    
    class ColumnAnalysis {
        
        private(set) var distributionGraph = DistributionGraph()
        private(set) var probabilityGraph = ProbabilityGraph()
        
        private(set) var columnSelectedBackground = UIColor(red: CGFloat(220.0/255.0), green: CGFloat(220.0/255.0), blue: CGFloat(220.0/255.0), alpha: 1.0)
        
        class DistributionGraph {
            
            var backgroundColor = UIColor.white
            var xAxisTextColor = UIColor.black
            var yAxisTextColor = UIColor.black
            var barColor = UIColor(red: 110.0/255.0, green: 157.0/255.0, blue: 216.0/255.0, alpha: 1.0)
            
            var frequencyLineColor = UIColor.red
            var frequencyLineWidth = CGFloat(2.0)
            
            var normalLineColor = UIColor.brown
            var normalLineWidth = CGFloat(2.0)
        }
        
        class ProbabilityGraph {
            
            var backgroundColor = UIColor.white
            var xAxisTextColor = UIColor.black
            var yAxisTextColor = UIColor.black
            var circleColor = UIColor(red: 110.0/255.0, green: 157.0/255.0, blue: 216.0/255.0, alpha: 1.0)
            
            var normalLineColor = UIColor.red
            var normalLineWidth = CGFloat(2.0)
        }
    }
    
    class Heatmap {
        
        var maxColor = UIColor(red: CGFloat(94.0/255.0), green: CGFloat(15.0/255.0), blue: CGFloat(32.0/255.0), alpha: 1.0)
        var minColor = UIColor(red: CGFloat(17.0/255.0), green: CGFloat(49.0/255.0), blue: CGFloat(94.0/255.0), alpha: 1.0)
        var valuesVisible = true
        
        func colorForValue(value: Double) -> UIColor {
                    
            let whiteColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            if value > 0.0 {
                let min = 0.0
                let max = 1.0
                let percentage = CGFloat( (value - min) / (max - min))
                return whiteColor.interpolateRGBColorTo(self.maxColor, fraction: percentage)!
            }
            else {
                let min = -1.0
                let max = 0.0
                let percentage = CGFloat( (value - min) / (max - min))
                return self.minColor.interpolateRGBColorTo(whiteColor, fraction: percentage)!
            }
        }
        func interpolateRGBColorFrom(_ from: UIColor, end: UIColor, fraction: CGFloat) -> UIColor? {
            let f = min(max(0, fraction), 1)

            guard let c1 = from.cgColor.components, let c2 = end.cgColor.components else { return nil }

            let r: CGFloat = CGFloat(c1[0] + (c2[0] - c1[0]) * f)
            let g: CGFloat = CGFloat(c1[1] + (c2[1] - c1[1]) * f)
            let b: CGFloat = CGFloat(c1[2] + (c2[2] - c1[2]) * f)
            let a: CGFloat = CGFloat(c1[3] + (c2[3] - c1[3]) * f)
            
            return UIColor(red: r, green: g, blue: b, alpha: a)
        }
    }
    
    class Playground {
        
        private(set) var userGraph = UserGraph()
        
        class UserGraph {
            let graphBackgroundColor = UIColor.white
            let titleColor: UIColor = UIColor.black
            let yAxisTextColor: UIColor = UIColor.black
            let xAxisTextColor: UIColor = UIColor.black
            
            let lineColor: UIColor = UIColor.cyan
            let circleColor: UIColor = UIColor.cyan
            let barColor: UIColor = UIColor.cyan
            
            let lineWidth =  5.0
            let circleSize = 10.0
        }
    }
    
    
    
    
    
}
