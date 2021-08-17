//
//  HeatMapLabelContainerView.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 29.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit

class HeatMapLabelContainerView: UIView {
    
    private var labelViews = [UILabel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func labelWidth() -> CGFloat {
        return CGFloat(250.0)
    }
    
    func setLabels(_ labels: [String]?, alignment: NSTextAlignment = .left) -> CGFloat {
        
        var totalHeight = CGFloat(0)
        for l in labelViews {
            l.removeFromSuperview()
        }
        labelViews.removeAll()
        
        guard let labels = labels else {
            return totalHeight
        }
                
        let labelHeight = CGFloat(50.0)
        let labelWidth = self.labelWidth()
        
        for (i, text) in labels.enumerated() {
            
            let x = CGFloat(0)
            let y = CGFloat(i) * labelHeight
            let w = labelWidth
            let h = labelHeight
            
            let label = InsetLabel(frame: CGRect(x: x, y: y, width: w, height: h))
            label.insets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
            label.text = text
            label.textAlignment = alignment
            labelViews.append(label)
            self.addSubview(label)
            
            totalHeight += (x + labelHeight)
        }
        return totalHeight
    }
}
