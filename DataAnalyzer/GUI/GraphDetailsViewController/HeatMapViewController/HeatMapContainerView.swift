//
//  HeatMapContainerView.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 29.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit

class HeatMapContainerView: UIView {
    
    private var maxColor: UIColor!
    private var minColor: UIColor!
    private var valuesVisible: Bool = false
    
    private(set) var labels: [String]?
    private(set) var corrolation: [[Double]]?
    
    private var leftAxisLabelContainer = HeatMapLabelContainerView()
    private var bottomAxisLabelContainer = HeatMapLabelContainerView()
    private var heatMapMatrixView = HeatMapMatrixView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        
        self.addSubview(leftAxisLabelContainer)
        self.addSubview(bottomAxisLabelContainer)
        self.addSubview(heatMapMatrixView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColors(max: UIColor, min: UIColor) {
        maxColor = max
        minColor = min
    }
    
    func setValuesVisible(_ visible: Bool) {
        valuesVisible = visible
    }
    
    func setLabels(_ labels: [String]?, corrolation: [[Double]]?) {
        
        self.labels = labels
        
        if leftAxisLabelContainer.superview != nil {
            leftAxisLabelContainer.removeFromSuperview()
        }
        if bottomAxisLabelContainer.superview != nil{
            bottomAxisLabelContainer.removeFromSuperview()
        }
        if heatMapMatrixView.superview != nil{
            heatMapMatrixView.removeFromSuperview()
        }
        
        guard let labels = labels else {
            return
        }
        
        leftAxisLabelContainer = HeatMapLabelContainerView()
        bottomAxisLabelContainer = HeatMapLabelContainerView()
        heatMapMatrixView = HeatMapMatrixView()
        heatMapMatrixView.minColor = minColor
        heatMapMatrixView.maxColor = maxColor
        heatMapMatrixView.valuesVisible = valuesVisible
        
        self.addSubview(leftAxisLabelContainer)
        self.addSubview(bottomAxisLabelContainer)
        self.addSubview(heatMapMatrixView)
        
        let edgeInsets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        
        let height = leftAxisLabelContainer.setLabels(labels, alignment: .right)
        let width = leftAxisLabelContainer.labelWidth()
        leftAxisLabelContainer.frame = CGRect(x: edgeInsets.left, y: width + edgeInsets.top, width: width, height: height)

        let _ = bottomAxisLabelContainer.setLabels(labels)
        bottomAxisLabelContainer.frame = CGRect(x: ((height + width) / 2.0) + edgeInsets.left, y: (-(height - width)/2.0) + edgeInsets.top, width: width, height: height)
        bottomAxisLabelContainer.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)

        heatMapMatrixView.setSize(labels.count)
        heatMapMatrixView.backgroundColor = UIColor.white
        heatMapMatrixView.setValues(corrolation!)
        heatMapMatrixView.frame = CGRect(x: width + edgeInsets.left, y: width + edgeInsets.top, width: height, height: height)

        var frame = self.frame
        frame.size.width = width + height + edgeInsets.left + edgeInsets.right
        frame.size.height = width + height + edgeInsets.top + edgeInsets.bottom
        self.frame = frame
    }
}
