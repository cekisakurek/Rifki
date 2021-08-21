//
//  UserGraphViewModel.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 22.08.21.
//  Copyright © 2021 cekisakurek. All rights reserved.
//

import SwiftUI
import Charts

final class UserGraphViewModel: ObservableObject {
    
    @Published var data: CombinedChartData?
    
    @Published var dataLoaded = false
    
    @Published var name = ""
    
    @Published var xAxis = ""
    @Published var yAxis = ""
    
    func notifyLoaded() {
        // wait 0.75 second for the push animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            [weak self] in
            self?.dataLoaded = true
        }
    }
    
    func fetch(graph: Graph) {
        if let graphData = graph.data?.allObjects as? [GraphData],
           let dataset = graph.workset {
            
            for graphDataAxes in graphData {
                let xAxis = graphDataAxes.xAxis!
                let yAxis = graphDataAxes.yAxis!
                
                self.xAxis = xAxis
                self.yAxis = yAxis
                if let name = graph.name {
                    self.name = name
                }
                
                let x = dataset.headers?.firstIndex(of: xAxis)
                let y = dataset.headers?.firstIndex(of: yAxis)
                
                let xColumnAnalysis = ColumnAnalysis(data: dataset.data!, index: x!, name: xAxis)
                let yColumnAnalysis = ColumnAnalysis(data: dataset.data!, index: y!, name: yAxis)
                
                let xArray = xColumnAnalysis.dataAsDoubleArray()
                let yArray = yColumnAnalysis.dataAsDoubleArray()
                
                if graph.type == "Line" {
                    
                    var entries = [ChartDataEntry]()
                    
                    for i in 0..<xArray.count {
                        
                        let entry = ChartDataEntry(x: xArray[i], y: yArray[i])
                        entries.append(entry)
                    }
                    entries.sort(by: { $0.x < $1.x })
                    
                    let lineColor = UIColor.black
                    
                    var lineWidth = 5.0
                    if graphDataAxes.lineWidth > 0.0 {
                        lineWidth = graphDataAxes.lineWidth
                    }
                    
                    let chartDataSet = LineChartDataSet(entries: entries)
                    chartDataSet.colors = [lineColor]
                    chartDataSet.mode = .linear
                    chartDataSet.drawCirclesEnabled = false
                    chartDataSet.lineWidth = CGFloat(lineWidth)
                    
                    let combinedChart = CombinedChartData()
                    combinedChart.lineData = LineChartData(dataSet: chartDataSet)
                    self.data = combinedChart
                    notifyLoaded()
                }
                else if graph.type == "Bar" {

                    var entries = [BarChartDataEntry]()
                    for i in 0..<xArray.count {

                        let entry = BarChartDataEntry(x: xArray[i], y: yArray[i])
                        entries.append(entry)
                    }
                    entries.sort(by: { $0.x < $1.x })

                    let color = UIColor.black

                    let chartDataSet = BarChartDataSet(entries: entries)
                    chartDataSet.colors = [color]
                    let combinedChart = CombinedChartData()
                    combinedChart.barData = BarChartData(dataSet: chartDataSet)
                    self.data = combinedChart
                    notifyLoaded()
                }
                else if graph.type == "Scatter" {

                    var entries = [ChartDataEntry]()
                    for i in 0..<xArray.count {

                        let entry = ChartDataEntry(x: xArray[i], y: yArray[i])
                        entries.append(entry)
                    }
                    entries.sort(by: { $0.x < $1.x })

                    let color = UIColor.black
                    let circleSize = graphDataAxes.circleSize

                    let chartDataSet = ScatterChartDataSet(entries: entries)
                    chartDataSet.drawValuesEnabled = false
                    chartDataSet.colors = [color]
                    chartDataSet.scatterShapeSize = CGFloat(circleSize)
                    chartDataSet.setScatterShape(.circle)

                    let combinedChart = CombinedChartData()
                    combinedChart.scatterData = ScatterChartData(dataSet: chartDataSet)
                    self.data = combinedChart
                    notifyLoaded()
                }
            }
        }
    }
}
