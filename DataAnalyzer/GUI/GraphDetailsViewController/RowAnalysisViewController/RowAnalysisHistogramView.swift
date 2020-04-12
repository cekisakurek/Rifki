//
//  RowAnalysisHistogramView.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 06.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit

class RowAnalysisHistogramView: UIView {
    
    private var plotView: BarPlotView!
    private var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.text = NSLocalizedString("Distribution", comment: "")
        self.addSubview(titleLabel)
        
        
        plotView = BarPlotView(frame: .zero)
        plotView.translatesAutoresizingMaskIntoConstraints = false
//        plotView.minimumBarWidth = 5.5
//        plotView.axisLineWidth = 1.0
        plotView.backgroundColor = UIColor.red
//        plotView.plotInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.addSubview(plotView)
        
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: plotView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            plotView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            plotView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            plotView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            
        ])

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ data: [BarDataPoint]?) {
        
//        self.plotView.setData(points: data)
        

        
        
        
        
//        let (prices, _) = (graphRawData?.column(atIndex: 80))!

        
        
//        let (_, maxFreq) = findMaxFrequency(data: prices as! [Double])

//        let c = probabilityDistrubition(data: prices as! [Double])
        
//        let (b,m10) = lsr(c)
        
//        let y = (m10*c[1450][0]) + b
//
//        let (frequencies, maxFreq, minFreq) = data.frequencies()
//
//        let exponent = trunc(log(maxFreq) / log(10.0))
//
//        let mantissa = maxFreq / pow(10, trunc(log(maxFreq) / log(10.0)))
//        let r = mantissa.rounded(toPlaces: 2) * pow(10.0, exponent)
//
//        let normalized = data.normalized()
//
//
//
//
//        let trimmed = normalized.trim(fromDigit: 4)
//
//        var hist = trimmed.histogram()
//
//        let min = data.minValue()
//        let max = data.maxValue()
//
//
//        let e = Double(Int(log(max) / log(10)))
//        let m = pow(10.0, e)
//        let nearest = Int(m) * Int(round(max / m))
//
//        let lastElement = (Double(nearest) - min) / (max - min)
//
//        hist[Double(lastElement)] = 0
//
//
//        let sortedKeys = hist.keys.sorted()
//
//        var dataPoints = [BarDataPoint]()
//
//        for normalizedPrice in sortedKeys {
//            let freq = Double(hist[normalizedPrice]!)
//            let realPrice = Int(normalizedPrice * (max - min) + min)
//            let xPoint = PointDoubleValue(value: normalizedPrice, label: String(realPrice))
//            let yPoint = PointDoubleValue(value: freq, label: "Freq")
//            let point = BarDataPoint(x: xPoint, y: yPoint)
//            dataPoints.append(point)
//
//        }
        
        
//        plotView.setXAxisLabels(labels: ["0", String(Double(nearest)*(1.0/4.0)), String(Double(nearest)*(2.0/4.0)), String(Double(nearest)*(3.0/4.0)), String(nearest)])
//        
//        
//        var labels = [String]()
//        for i in 0...9 {
//            let str = (r * Double(i) / 8.0).string(fractionDigits: Int((-exponent) + 1))
//            labels.append(str)
//        }
//        
//        
//        plotView.setYAxisLabels(labels: labels)
//        
//        barPlotView.setYAxisLabels(labels: ,String(r*2.0/8.0),String(r*3.0/8.0),String(r*4.0/8.0),String(r*5.0/8.0),String(r*6.0/8.0),String(r*7.0/8.0),String(r*1.0/8.0)])
//        plotView.setData(points: dataPoints)
    }
}
