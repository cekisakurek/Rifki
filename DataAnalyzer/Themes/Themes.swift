//
//  DistributionGraphTheme.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 11.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit

class DistributionGraphTheme {
    
    var backgroundColor = UIColor.white
    var xAxisTextColor = UIColor.black
    var yAxisTextColor = UIColor.black
    var barColor = UIColor(red: 140.0/255.0, green: 234.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    
    var frequencyLineColor = UIColor.red
    var frequencyLineWidth = CGFloat(2.0)
    
    var normalLineColor = UIColor.brown
    var normalLineWidth = CGFloat(2.0)
}


class ProbabilityGraphTheme {
    
    var backgroundColor = UIColor.white
    var xAxisTextColor = UIColor.black
    var yAxisTextColor = UIColor.black
    var circleColor = UIColor(red: 140.0/255.0, green: 234.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    
    var normalLineColor = UIColor.red
    var normalLineWidth = CGFloat(2.0)
}

class HeatmapTheme {
    
    var maxColor = UIColor(red: CGFloat(94.0/255.0), green: CGFloat(15.0/255.0), blue: CGFloat(32.0/255.0), alpha: 1.0)
    var minColor = UIColor(red: CGFloat(17.0/255.0), green: CGFloat(49.0/255.0), blue: CGFloat(94.0/255.0), alpha: 1.0)
    var valuesVisible = false
}

