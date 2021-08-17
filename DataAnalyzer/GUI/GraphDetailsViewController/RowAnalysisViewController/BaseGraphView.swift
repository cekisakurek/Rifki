//
//  BaseGraphView.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 17.08.21.
//  Copyright © 2021 cekisakurek. All rights reserved.
//

import UIKit
import Charts

class BaseGraphView: UIView, ChartViewDelegate {
    
    var graphView: CombinedChartView!
    var leftAxisTitleLabel: UILabel!
    var bottomAxisTitleLabel: UILabel!
    var titleLabel: UILabel!
     
    func setLeftAxisLabelTextColor(_ color: UIColor) {
        self.leftAxisTitleLabel.textColor = color
    }
    
    func setBottomAxisLabelTextColor(_ color: UIColor) {
        self.bottomAxisTitleLabel.textColor = color
    }
    
    func setNoDataLabelTextColor(_ color: UIColor) {
        self.graphView.noDataTextColor = color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        self.graphView = CombinedChartView(frame: .zero)
        self.graphView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.graphView)
        
        let axisLabelFonts = UIFont.systemFont(ofSize: 13.0)
        let plotTitleFont = UIFont.boldSystemFont(ofSize: 16.0)
        
        
        self.leftAxisTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100.0, height: 20.0))
        self.leftAxisTitleLabel.font = axisLabelFonts
        
        self.leftAxisTitleLabel.textAlignment = .center
        
        self.leftAxisTitleLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        self.addSubview(leftAxisTitleLabel)

        self.bottomAxisTitleLabel = UILabel(frame: .zero)
        self.bottomAxisTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.bottomAxisTitleLabel.font = axisLabelFonts
        
        self.bottomAxisTitleLabel.textAlignment = .center
        self.addSubview(bottomAxisTitleLabel)
        
        
        self.titleLabel = UILabel(frame: .zero)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.font = plotTitleFont
        self.titleLabel.textColor = UIColor.black
        self.titleLabel.textAlignment = .center
        self.addSubview(self.titleLabel)
        
        
        NSLayoutConstraint.activate([
        
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.graphView.topAnchor),

            self.graphView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor),
            self.graphView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0),
            self.graphView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.graphView.bottomAnchor.constraint(equalTo: self.bottomAxisTitleLabel.topAnchor),
            self.graphView.heightAnchor.constraint(greaterThanOrEqualToConstant: 150.0),

            self.bottomAxisTitleLabel.topAnchor.constraint(equalTo: self.graphView.bottomAnchor),
            self.bottomAxisTitleLabel.leadingAnchor.constraint(equalTo: self.graphView.leadingAnchor),
            self.bottomAxisTitleLabel.trailingAnchor.constraint(equalTo: self.graphView.trailingAnchor),
            self.bottomAxisTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
        ])
        updateGraph()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(frame: .zero)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.frame.width > 0 {
            leftAxisTitleLabel.frame = CGRect(x: self.graphView.frame.origin.x - 20.0,
                                                              y: self.graphView.frame.origin.y + 100.0,
                                                              width: leftAxisTitleLabel.frame.size.width, height: leftAxisTitleLabel.frame.height)

        }
    }
    
    func setData(_ data: CombinedChartData?) {
        updateGraph()
        self.graphView.data = data
        self.graphView.animate(xAxisDuration: 0.25, yAxisDuration: 0.25)
    }
    
    
    func updateGraph() {
        
        self.graphView.noDataText = NSLocalizedString("No chart data available.", comment: "")
        self.graphView.isUserInteractionEnabled = false
        self.graphView.delegate = self
        self.graphView.legend.enabled = false
        self.graphView.backgroundColor = self.backgroundColor
        self.graphView.rightAxis.axisMinimum = 0.0
        self.graphView.xAxis.gridColor = .clear
        self.graphView.leftAxis.gridColor = .clear
        self.graphView.rightAxis.gridColor = .clear
        self.graphView.notifyDataSetChanged()
        self.graphView.setNeedsDisplay()
    }
}



class DistributionGraphView: BaseGraphView {

    public var theme = DistributionGraphTheme()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setLeftAxisLabelTextColor(theme.yAxisTextColor)
        self.setBottomAxisLabelTextColor(theme.xAxisTextColor)
        
        self.leftAxisTitleLabel.text = NSLocalizedString("Frequency", comment: "")
        self.bottomAxisTitleLabel.text = NSLocalizedString("Values", comment: "")
        self.titleLabel.text = NSLocalizedString("Distribution", comment: "")
        
        
        
        
        self.updateGraph()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(frame: .zero)
    }
    

        
    override func updateGraph() {
        
        self.graphView.noDataTextColor = theme.yAxisTextColor
        self.leftAxisTitleLabel.textColor = theme.yAxisTextColor
        self.bottomAxisTitleLabel.textColor = theme.xAxisTextColor


        self.graphView.noDataText = NSLocalizedString("No chart data available.", comment: "")
        self.graphView.isUserInteractionEnabled = false
        self.graphView.delegate = self
        self.graphView.legend.enabled = false
        self.graphView.backgroundColor = theme.backgroundColor
        let xAxis = self.graphView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = theme.xAxisTextColor

        self.graphView.leftAxis.labelTextColor = theme.yAxisTextColor
        self.graphView.rightAxis.labelTextColor = theme.yAxisTextColor

        self.graphView.rightAxis.axisMinimum = 0.0

        self.graphView.xAxis.gridColor = .clear
        self.graphView.leftAxis.gridColor = .clear
        self.graphView.rightAxis.gridColor = .clear

        self.graphView.notifyDataSetChanged()
        self.graphView.setNeedsDisplay()
    }
}


class ProbabilityGraphView: BaseGraphView {
    
    public var theme = ProbabilityGraphTheme()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        self.setLeftAxisLabelTextColor(theme.yAxisTextColor)
        self.setBottomAxisLabelTextColor(theme.xAxisTextColor)
        
        self.leftAxisTitleLabel.text = NSLocalizedString("Ordered Values", comment: "")
        self.bottomAxisTitleLabel.text = NSLocalizedString("Theoretical Quantiles", comment: "")
        self.titleLabel.text = NSLocalizedString("Probability", comment: "")
        
        self.updateGraph()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(frame: .zero)
    }
    
    override func updateGraph() {
        
        
        self.leftAxisTitleLabel.textColor = theme.yAxisTextColor
        self.bottomAxisTitleLabel.textColor = theme.xAxisTextColor
        
        self.graphView.delegate = self
        self.graphView.legend.enabled = false
        self.graphView.backgroundColor = theme.backgroundColor
        let xAxis = self.graphView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = theme.xAxisTextColor
        
        self.graphView.autoScaleMinMaxEnabled = false
        
        self.graphView.xAxis.gridColor = .clear
        self.graphView.leftAxis.gridColor = .clear
        self.graphView.rightAxis.gridColor = .clear
        
        self.graphView.leftAxis.labelTextColor = theme.yAxisTextColor
        self.graphView.rightAxis.labelTextColor = theme.yAxisTextColor
        self.graphView.isUserInteractionEnabled = false
                
        self.graphView.noDataTextColor = theme.yAxisTextColor
        self.graphView.noDataText = NSLocalizedString("No chart data available.", comment: "")

    }
}

