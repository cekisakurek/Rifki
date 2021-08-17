//
//  HeatMapMatrixView.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 29.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit

class HeatMapMatrixView: UIView {
    
    var maxColor: UIColor!
    var minColor: UIColor!
    var valuesVisible: Bool = false
    
    var width: Int = 0
    var height: Int = 0
    
    var values: [[Double]]?
    
    let valueFormatter = NumberFormatter()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        valueFormatter.minimumFractionDigits = 3
        valueFormatter.maximumFractionDigits = 5
    }
    
    func stringFromValue(_ value: Double) -> String {
        return valueFormatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ frame: CGRect) {
        
        let height = frame.height / CGFloat(self.width)
        let width = frame.width / CGFloat(self.width)
        for w in 0..<self.width {
            for h in 0..<self.height {
                
                UIColor.white.setFill()
                if values!.count > h {
                    let row = values![h]
                    if row.count > w {
                        
                        let drect = CGRect(x: (CGFloat(w) * width), y: (CGFloat(h) * height), width: (CGFloat(width)), height: (CGFloat(height)))
                        let bpath: UIBezierPath = UIBezierPath(rect: drect)
                        
                        let col = row[w]
                        
                        let color = colorForValue(value: col)
                        color.setFill()
                        bpath.fill()
                        
                        if valuesVisible {
                            let valueString = stringFromValue(col)// String(format:"%.2f",col)
                            let paragraphStyle = NSMutableParagraphStyle()
                            paragraphStyle.alignment = .center
                            let font = UIFont.systemFont(ofSize: 10)
                            let attributes = [
                                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                                NSAttributedString.Key.font: font,
                                NSAttributedString.Key.foregroundColor: UIColor.black
                            ]
                            
                            let textInset = drect.insetBy(dx: 0, dy: (drect.height - font.pointSize)/2)
                            valueString.draw(in: textInset, withAttributes: attributes)
                        }
                    }
                }
            }
        }
    }
    
    func colorForValue(value: Double) -> UIColor {
                
        let whiteColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        if value > 0.0 {
            let min = 0.0
            let max = 1.0
            let percentage = CGFloat( (value - min) / (max - min))
            return whiteColor.interpolateRGBColorTo(maxColor, fraction: percentage)!
        }
        else {
            let min = -1.0
            let max = 0.0
            let percentage = CGFloat( (value - min) / (max - min))
            return minColor.interpolateRGBColorTo(whiteColor, fraction: percentage)!
        }
    }
    
    func setSize(_ size: Int? = 0) {
        self.width = size!
        self.height = size!
        setNeedsDisplay()
    }
    
    func setValues(_ values: [[Double]]) {
        self.values = values
    }
}
