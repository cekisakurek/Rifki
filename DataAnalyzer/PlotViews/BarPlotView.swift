//
//  BarPlotView2.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 06.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit


class BarPlotCanvasView: PlotBaseCanvas {
    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//
//        if let context = UIGraphicsGetCurrentContext() {
//
//            for circle in circles {
//
//
//                context.addEllipse(in: circle.frame)
//                if let color = circle.color {
//                    context.setFillColor(color.cgColor)
//                }
//                else {
//                    context.setFillColor(UIColor.blue.cgColor)
//                }
//
//                context.fillPath()
//            }
//
//        }
//    }
//
}



class BarPlotView: PlotBaseView {
    
//    private var titleLabel: UILabel!
    
    private var barViews = [UIView]()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        self.plotInsets = UIEdgeInsets(top: 30, left: 50, bottom: 50, right: 50)
        self.axisLineWidth = CGFloat(2.0)
        
        self.plotCanvas = BarPlotCanvasView(frame: .zero)
        self.plotCanvas.backgroundColor = UIColor.clear
        self.plotCanvas.layer.borderColor = UIColor.lightGray.cgColor
        self.plotCanvas.layer.borderWidth = 1.0
        self.addSubview(self.plotCanvas)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String?) {
//        titleLabel.text = title
    }
    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//
//        if let context = UIGraphicsGetCurrentContext() {
//            context.setLineCap(.round)
//            context.setStrokeColor(UIColor.black.cgColor)
//            context.setLineWidth(axisLineWidth)
//
//            context.beginPath()
//            context.move(to: CGPoint(x: plotInsets.left, y: plotInsets.top))
//            context.addLine(to: CGPoint(x: plotInsets.left, y: bounds.height - plotInsets.bottom))
//
//            context.move(to: CGPoint(x: plotInsets.left, y: bounds.height - plotInsets.bottom))
//            context.addLine(to: CGPoint(x: bounds.width - plotInsets.right, y: bounds.height - plotInsets.bottom))
//
//            context.strokePath()
//        }
//    }
    
    func setData(_ data: [BarDataPoint]?, animated: Bool = true) {
        
        
        let canvas = self.plotCanvas as! BarPlotCanvasView
        
        for barView in barViews {
            barView.removeFromSuperview()
        }
        
        barViews.removeAll()
        textItems.removeAll()
        
        guard let data = data else {
            return
        }
        
        let minXValue = roundedMin(data.minXValue())
        let maxXValue = roundedMax(data.maxXValue())
//
//
        let minYValue = roundedMin(data.minYValue())
        let maxYValue = roundedMax(data.maxYValue())//data.maxYValue()
        
        let plotWidth = canvas.bounds.width
        let plotHeight = canvas.bounds.height
        
          
        let startX = CGFloat(0.0)
        let startY = CGFloat(0.0)
        
        let barWidthToUse = floor(plotWidth / CGFloat(data.count))
        
        
        for (i, point) in data.enumerated() {
        

            var volume = CGFloat(0.0) //
            let x = startX + (CGFloat(i) * barWidthToUse)
            var y = plotHeight + startY - volume
 
            let barView = UIView(frame: .zero)
            barView.frame = CGRect(x: x, y: y, width: barWidthToUse, height: volume)
            barView.backgroundColor = UIColor.green
            barView.layer.borderColor = UIColor.black.cgColor
            barView.layer.borderWidth = 1.0
            barViews.append(barView)
            canvas.addSubview(barView)
            
            volume = floor(((plotHeight) * CGFloat(point.y.value)) / CGFloat(maxYValue))
            y = plotHeight + startY - volume
            
            if animated {

                UIView.animate(withDuration: 0.5) {
                    barView.frame = CGRect(x: x, y: y, width: barWidthToUse, height: volume)
                }
            }
            else {
                barView.frame = CGRect(x: x, y: y, width: barWidthToUse, height: volume)
            }
            
        }

        addYLabel(value: maxYValue, max: maxYValue, min: minYValue)
        setNeedsDisplay()
    }
    
//    var xAxisLabel: Double? {
//        didSet {
//
//            guard let xAxisLabel = xAxisLabel else {
//                textItems.removeAll()
//                setNeedsDisplay()
//                return
//            }
//
//            let font = UIFont.systemFont(ofSize: 10)
//            let attrs = [ NSAttributedString.Key.font: font ]
//
//            let max = roundedMax((xAxisLabel))
//
//            let numberFormatter = NumberFormatter()
//            numberFormatter.usesSignificantDigits = true
//            numberFormatter.numberStyle = .decimal
//            let formattedNumber = numberFormatter.string(from: NSNumber(value:max))
//
//
//            let xValue = formattedNumber!
//            let textSize: CGSize = xValue.size(withAttributes: attrs)
//
//
//            let xLabelItem = BarPlotTextItem(value: xValue, basePoint: CGPoint(x: self.bounds.size.width - textSize.width/2.0 - self.plotInsets.right,
//                                                                               y: bounds.height - plotInsets.bottom + textSize.height))
//
////            textItems.append(xLabelItem)
//            setNeedsDisplay()
//        }
//    }
//    var yAxisLabel: Double? {
//        didSet {
//            guard let yAxisLabel = yAxisLabel else {
//                textItems.removeAll()
//                setNeedsDisplay()
//                return
//            }
//
//            let max = roundedMax((yAxisLabel))
//
//            let numberFormatter = NumberFormatter()
//            numberFormatter.usesSignificantDigits = true
//            numberFormatter.numberStyle = .decimal
//            let formattedNumber = numberFormatter.string(from: NSNumber(value:max))
//
//
//            let yValue = formattedNumber!
//            let font = UIFont.systemFont(ofSize: 10)
//            let attrs = [ NSAttributedString.Key.font: font ]
//
//            let textSize: CGSize = yValue.size(withAttributes: attrs)
//
//
//
//
//            let yLabelItem = BarPlotTextItem(value: yValue, basePoint: CGPoint(x: self.plotInsets.left + textSize.width/2.0,
//                                                                               y: self.plotInsets.top - textSize.height))
////            textItems.append(yLabelItem)
//            setNeedsDisplay()
//        }
//    }
   
}
