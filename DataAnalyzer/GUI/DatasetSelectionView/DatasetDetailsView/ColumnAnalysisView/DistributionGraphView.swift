//
//  DistributionGraphView.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 19.08.21.
//  Copyright © 2021 cekisakurek. All rights reserved.
//

import SwiftUI
import Charts

import Charts

class BaseGraphView: UIView, ChartViewDelegate {
    
    var graphView: CombinedChartView!

    func setNoDataLabelTextColor(_ color: UIColor) {
        self.graphView.noDataTextColor = color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        self.graphView = CombinedChartView(frame: .zero)
        self.graphView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.graphView)
        
        NSLayoutConstraint.activate([
            self.graphView.topAnchor.constraint(equalTo: self.topAnchor),
            self.graphView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.graphView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.graphView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        updateGraph()
    }
    
//    override var intrinsicContentSize: CGSize {
//        return CGSize(width: 500, height: 150)
//    }
    
    required convenience init?(coder: NSCoder) {
        self.init(frame: .zero)
    }

    func setData(_ data: CombinedChartData?) {
        updateGraph()
        self.graphView.data = data
//        self.graphView.animate(xAxisDuration: 0.25, yAxisDuration: 0.25)
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

struct DistributionGraphViewRepresentation: UIViewRepresentable  {
    
    var data: HistorgramResult?
    
    @Environment(\.appTheme) var appTheme: AppTheme
    
    init(data: HistorgramResult?) {
        self.data = data
    }
    
    func makeUIView(context: Context) -> DistributionGraphView {
        let view = DistributionGraphView(frame: .zero)
        
        if let data = data {
            let histogramDataSet = BarChartDataSet(entries: data.histogramEntries)
            
            histogramDataSet.drawValuesEnabled = false
            histogramDataSet.axisDependency = .right
            histogramDataSet.colors = [appTheme.columnAnalysis.distributionGraph.barColor]
            
            let histogramData = BarChartData(dataSets: [histogramDataSet])
            histogramData.barWidth = data.width
            
            let frequenciesDataSet = LineChartDataSet(entries: data.frequencies, label: NSLocalizedString("Frequency", comment: ""))
            frequenciesDataSet.colors = [appTheme.columnAnalysis.distributionGraph.frequencyLineColor]
            frequenciesDataSet.mode = .cubicBezier
            frequenciesDataSet.drawCirclesEnabled = false
            frequenciesDataSet.lineWidth = appTheme.columnAnalysis.distributionGraph.frequencyLineWidth
            frequenciesDataSet.axisDependency = .left
            
            let normalDataSet = LineChartDataSet(entries: data.normal)
            normalDataSet.colors = [appTheme.columnAnalysis.distributionGraph.normalLineColor]
            normalDataSet.mode = .cubicBezier
            normalDataSet.drawCirclesEnabled = false
            normalDataSet.lineWidth = appTheme.columnAnalysis.distributionGraph.normalLineWidth
            normalDataSet.axisDependency = .left
            
            
            let combined = CombinedChartData()
            combined.lineData = LineChartData(dataSets: [frequenciesDataSet, normalDataSet])
            combined.barData = histogramData
            
            view.setData(combined)
        }
        return view
    }
    
    func updateUIView(_ uiView: DistributionGraphView, context: Context) {
        
    }
    
    class DistributionGraphView: BaseGraphView {

        @Environment(\.appTheme) var appTheme: AppTheme
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.updateGraph()
        }
        
        required convenience init?(coder: NSCoder) {
            self.init(frame: .zero)
        }

        override func updateGraph() {
            
            self.graphView.noDataTextColor = appTheme.columnAnalysis.distributionGraph.yAxisTextColor

            self.graphView.noDataText = NSLocalizedString("No chart data available.", comment: "")
            self.graphView.isUserInteractionEnabled = false
            self.graphView.delegate = self
            self.graphView.legend.enabled = false
            self.graphView.backgroundColor = appTheme.columnAnalysis.distributionGraph.backgroundColor
            let xAxis = self.graphView.xAxis
            xAxis.labelPosition = .bottom
            xAxis.labelTextColor = appTheme.columnAnalysis.distributionGraph.xAxisTextColor

            self.graphView.leftAxis.labelTextColor = appTheme.columnAnalysis.distributionGraph.yAxisTextColor
            self.graphView.rightAxis.labelTextColor = appTheme.columnAnalysis.distributionGraph.yAxisTextColor

            self.graphView.rightAxis.axisMinimum = 0.0

            self.graphView.xAxis.gridColor = .clear
            self.graphView.leftAxis.gridColor = .clear
            self.graphView.rightAxis.gridColor = .clear

            self.graphView.notifyDataSetChanged()
            self.graphView.setNeedsDisplay()
        }
    }
}
