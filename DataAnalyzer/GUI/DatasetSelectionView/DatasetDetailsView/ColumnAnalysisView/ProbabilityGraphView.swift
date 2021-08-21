//
//  ProbabilityGraphView.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 19.08.21.
//  Copyright © 2021 cekisakurek. All rights reserved.
//

import SwiftUI
import Charts

struct ProbabilityGraphViewRepresentation: UIViewRepresentable  {
    
    @Environment(\.appTheme) var appTheme: AppTheme
    
    var data: ProbabilityResult?
    
    
    init(data: ProbabilityResult?) {
        self.data = data
    }
    
    func makeUIView(context: Context) -> ProbabilityGraphView {
        let view = ProbabilityGraphView(frame: .zero)

        if let data = data {
            let normalDataSet = LineChartDataSet(entries: data.normal)
            normalDataSet.colors = [appTheme.columnAnalysis.probabilityGraph.normalLineColor]
            normalDataSet.mode = .linear
            normalDataSet.drawCirclesEnabled = false
            normalDataSet.lineWidth = appTheme.columnAnalysis.probabilityGraph.normalLineWidth
            
            let chartDataSet = ScatterChartDataSet(entries: data.probabilities)
            chartDataSet.drawValuesEnabled = false
            chartDataSet.setScatterShape(.circle)
            chartDataSet.colors = [appTheme.columnAnalysis.probabilityGraph.circleColor]
            
            let combined = CombinedChartData()
            combined.lineData = LineChartData(dataSet: normalDataSet)
            combined.scatterData = ScatterChartData(dataSets: [chartDataSet])
            
            view.setData(combined)
        }
        return view
    }
    
    func updateUIView(_ uiView: ProbabilityGraphView, context: Context) {
        
    }
    
    class ProbabilityGraphView: BaseGraphView {
        @Environment(\.appTheme) var appTheme: AppTheme
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.backgroundColor = UIColor.white
            self.updateGraph()
        }
        
        required convenience init?(coder: NSCoder) {
            self.init(frame: .zero)
        }
        
        override func updateGraph() {
            self.graphView.delegate = self
            self.graphView.legend.enabled = false
            self.graphView.backgroundColor = appTheme.columnAnalysis.probabilityGraph.backgroundColor
            let xAxis = self.graphView.xAxis
            xAxis.labelPosition = .bottom
            xAxis.labelTextColor = appTheme.columnAnalysis.probabilityGraph.xAxisTextColor
            
            self.graphView.autoScaleMinMaxEnabled = false
            
            self.graphView.xAxis.gridColor = .clear
            self.graphView.leftAxis.gridColor = .clear
            self.graphView.rightAxis.gridColor = .clear
            
            self.graphView.leftAxis.labelTextColor = appTheme.columnAnalysis.probabilityGraph.yAxisTextColor
            self.graphView.rightAxis.labelTextColor = appTheme.columnAnalysis.probabilityGraph.yAxisTextColor
            self.graphView.isUserInteractionEnabled = false
                    
            self.graphView.noDataTextColor = appTheme.columnAnalysis.probabilityGraph.yAxisTextColor
            self.graphView.noDataText = NSLocalizedString("No chart data available.", comment: "")

        }
    }
}

