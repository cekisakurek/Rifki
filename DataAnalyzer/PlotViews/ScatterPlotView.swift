//
//  ScatterPlotView.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 07.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit


struct ScatterCircle {
    var frame: CGRect
    var color: UIColor?
}



class ScatterPlotCanvasView: PlotBaseCanvas {
    
    fileprivate var circles = [ScatterCircle]()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        if let context = UIGraphicsGetCurrentContext() {
          
            for circle in circles {
                
                
                context.addEllipse(in: circle.frame)
                if let color = circle.color {
                    context.setFillColor(color.cgColor)
                }
                else {
                    context.setFillColor(UIColor.blue.cgColor)
                }
                
                context.fillPath()
            }
            
        }
    }
    
}




class ScatterPlotView: PlotBaseView {
    
//    private var canvas: ScatterPlotCanvasView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.plotInsets = UIEdgeInsets(top: 30, left: 50, bottom: 50, right: 50)
        self.axisLineWidth = CGFloat(2.0)
        
        self.backgroundColor = UIColor.white
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        
        
        self.plotCanvas = ScatterPlotCanvasView(frame: .zero)
        self.plotCanvas.backgroundColor = UIColor.clear
        self.plotCanvas.layer.borderColor = UIColor.lightGray.cgColor
        self.plotCanvas.layer.borderWidth = 1.0
        self.addSubview(self.plotCanvas)

        
        
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        self.plotCanvas.frame = self.bounds.inset(by: self.plotInsets)
//    }
//    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setData(_ data: [BarDataPoint]?, animated: Bool = true) {
        
        let canvas = self.plotCanvas as! ScatterPlotCanvasView
        canvas.circles.removeAll()
        textItems.removeAll()
        
        guard let data = data else {
            return
        }
        
        var values = [Double]()
        for point in data {
            values.append(point.x.value)
        }
        
        
        
        
        
        
        
        
        
        return;
        
        
        
        let minXValue = roundedMin(data.minXValue())
        let maxXValue = roundedMax(data.maxXValue())
        
        
        let minY = roundedMin(data.minYValue())
        let maxY = roundedMax(data.maxYValue())
        
        
        let radius = CGFloat(2.5)
        let plotWidth = canvas.bounds.width// - (radius * 2) - 100.0
        let plotHeight = canvas.bounds.height// - (radius * 2) - 100.0
//
        
        let xRange = (plotWidth / CGFloat(maxXValue - minXValue))
        let yRange = (plotHeight / CGFloat(maxY - minY))
        for point in data {
            
            
            let s = CGFloat(maxXValue - minXValue) + CGFloat(point.x.value + minXValue)
            let x = (s * xRange)// - radius * 2.0
            
            let hs = CGFloat(maxY - minY) - CGFloat(point.y.value - minY)
            let y = (hs * yRange) - radius * 2.0
            
            
            let circle = ScatterCircle(frame: CGRect(x: x, y: y, width: radius * 2, height: radius * 2), color: nil)
            
            canvas.circles.append(circle)
        }
                

        for i in Int(minXValue)...Int(maxXValue) {
            addXLabel(value: Double(i), max: maxXValue, min: minXValue)
        }
        
        
        addYLabel(value: maxY, max: maxY, min: minY)
        var yLabelValues = [Double]()
        for i in 1...4 {
            var val = roundedMin(maxY * (Double(i) / 4.0))
            if !yLabelValues.contains(val) {
                yLabelValues.append(val)
            }
            else {
                val = roundedMax(maxY * (Double(i) / 4.0))
                if !yLabelValues.contains(val) {
                    yLabelValues.append(val)
                }
            }
        }
        
        for val in yLabelValues {
            addYLabel(value: val, max: maxY, min: minY)
        }
        
        
        
        
        setNeedsDisplay()
        canvas.setNeedsDisplay()
    }
    
}
