//
//  PlotBaseView.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 07.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit

class PlotBaseCanvas: UIView {
    
}




class PlotBaseView: UIView {
    
    var plotInsets: UIEdgeInsets = UIEdgeInsets(top: 30, left: 50, bottom: 50, right: 50)
    var axisLineWidth = CGFloat(2.0)
    var textItems = [BarPlotTextItem]()
    
    var plotCanvas: PlotBaseCanvas!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.plotCanvas.frame = self.bounds.inset(by: self.plotInsets)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        if let context = UIGraphicsGetCurrentContext() {
            context.setLineCap(.round)
            context.setStrokeColor(UIColor.black.cgColor)
            context.setLineWidth(axisLineWidth)

            context.beginPath()
            context.move(to: CGPoint(x: plotInsets.left, y: plotInsets.top))
            context.addLine(to: CGPoint(x: plotInsets.left, y: bounds.height - plotInsets.bottom))

            context.move(to: CGPoint(x: plotInsets.left, y: bounds.height - plotInsets.bottom))
            context.addLine(to: CGPoint(x: bounds.width - plotInsets.right, y: bounds.height - plotInsets.bottom))

            context.strokePath()
            
            for textItem in textItems {
                
                textItem.value.drawWithBasePoint(basePoint: textItem.basePoint, angle: CGFloat(textItem.rotation), font: textItem.font)
            }
            
        }
    }
    
    func roundedMax(_ number: Double) -> Double {
        let exponent = log10(number)
        
        //        let mantissa = number / pow(10, exponent)
        
        let digits = number / pow(10, ceil(exponent + 1))
        
        let rounded = digits.roundedUp(toPlaces: 2)
        
        
        
        let result = rounded * pow(10,ceil(exponent+1))
        return result
    }
    
    func roundedMin(_ number: Double) -> Double {
        
        if number == 0 {
            return 0.0
        }
        
        let exponent = log10(abs(number))
        
        let digits = number / pow(10, ceil(exponent + 1))
        
        let rounded = digits.roundedDown(toPlaces: 2)
        
        let result = rounded * pow(10,ceil(exponent+1))
       
        return result
    }
    
    
    func addXLabel(value: Double, max: Double, min: Double) {
        
        let xRange = (self.plotCanvas.bounds.width / CGFloat(max - min))
        
        let numberFormatter = NumberFormatter()
        numberFormatter.usesSignificantDigits = true
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value: value))
        let yValue = formattedNumber!
        let font = UIFont.systemFont(ofSize: 10)
        let attrs = [ NSAttributedString.Key.font: font ]
        let textSize: CGSize = yValue.size(withAttributes: attrs)
        
        let s = CGFloat(max - min) + CGFloat(value + min)
        let x = (s * xRange) + plotInsets.left
        
        let y = self.plotCanvas.bounds.height + plotInsets.top + textSize.height
        
        let yLabelItem = BarPlotTextItem(value: yValue, basePoint: CGPoint(x: x,
                                                                           y: y))
        textItems.append(yLabelItem)
        
    }
    
    func addYLabel(value: Double, max: Double, min: Double) {
        
        let range = (self.plotCanvas.bounds.height / CGFloat(max - min))
        
        let numberFormatter = NumberFormatter()
        numberFormatter.usesSignificantDigits = true
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value: value))
        let yValue = formattedNumber!
        let font = UIFont.systemFont(ofSize: 10)
        let attrs = [ NSAttributedString.Key.font: font ]
        let textSize: CGSize = yValue.size(withAttributes: attrs)
        
        let x = plotInsets.left - (textSize.width/2.0)
        
        //        let y = self.canvas.bounds.height + plotInsets.top + textSize.height
        let hs = CGFloat(max - min) - CGFloat(value - min)
        let y = (hs * range) + plotInsets.top
        
        let yLabelItem = BarPlotTextItem(value: yValue, basePoint: CGPoint(x: x,
                                                                           y: y))
        textItems.append(yLabelItem)
        
    }
    
    
}
