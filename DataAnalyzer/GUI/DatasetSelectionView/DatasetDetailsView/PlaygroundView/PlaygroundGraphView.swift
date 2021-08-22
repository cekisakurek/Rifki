//
//  PlaygroundGraphView.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 21.08.21.
//  Copyright © 2021 cekisakurek. All rights reserved.
//

import SwiftUI
import CoreData
import Charts

struct PlaygroundGraphView: View {
    
    var graph: Graph?
    
    @StateObject var viewModel = UserGraphViewModel()
    
    var body: some View {
        if viewModel.dataLoaded {
            HStack(spacing: 16) {
                RotatedText(angle: .degrees(-90), text: viewModel.yAxis)
                VStack {
                    UserGraphViewRepresentation(data: viewModel.data)
                        .frame(maxWidth: .infinity)
                    Text(viewModel.xAxis)
                }
            }
            .padding()
            .navigationTitle(viewModel.name)
            .navigationBarItems(trailing: exportButton)
        }
        else {
            ProgressView()
                .onAppear() { viewModel.fetch(graph: graph!) }
        }
    }
    
    var exportButton: some View {
        Button(action: { viewModel.saveAsImage(size: CGSize(width: 1024, height: 1024)) }) {
            Image(systemName: "square.and.arrow.up")
        }
    }
    
    struct UserGraphViewRepresentation: UIViewRepresentable  {
        
        var data: CombinedChartData?
        
        init(data: CombinedChartData?) {
            self.data = data
        }
        
        func makeUIView(context: Context) -> UserGraphView {
            let view = UserGraphView(frame: .zero)
            view.setData(data)
            return view
        }
        
        func updateUIView(_ uiView: UserGraphView, context: Context) {
            
        }
    }
    
    class UserGraphView: UIView, ChartViewDelegate {
    
        var graphView: CombinedChartView!
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.backgroundColor = UIColor.white
        
            self.graphView = CombinedChartView(frame: frame)
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
        
        required convenience init?(coder: NSCoder) {
            self.init(frame: .zero)
        }
                
        func setData(_ data: CombinedChartData?) {
            
            self.graphView.data = data
            updateGraph()
            
        }
        
        func updateGraph() {
            
            self.graphView.noDataText = NSLocalizedString("No chart data available.", comment: "")
            
            self.graphView.isUserInteractionEnabled = false
            self.graphView.delegate = self
            self.graphView.legend.enabled = false
            self.graphView.backgroundColor = self.backgroundColor
            
        
            self.graphView.xAxis.granularity = 1.0
            self.graphView.xAxis.labelPosition = .bottom
            self.graphView.xAxis.drawGridLinesEnabled = false
            
            self.graphView.xAxis.labelFont = UIFont.systemFont(ofSize: 20)

            self.graphView.rightAxis.granularity = 1.0
            self.graphView.rightAxis.axisMinimum = 0.0
            self.graphView.leftAxis.axisMinimum = 0.0
            self.graphView.rightAxis.labelFont = UIFont.systemFont(ofSize: 20)
            self.graphView.leftAxis.labelFont = UIFont.systemFont(ofSize: 20)
            
            self.graphView.xAxis.gridColor = .clear
            self.graphView.leftAxis.gridColor = .clear
            self.graphView.rightAxis.gridColor = .clear

            guard let description = self.graphView.chartDescription else { return }
            description.text = ""
            self.graphView.notifyDataSetChanged()
            self.graphView.setNeedsDisplay()
        }
    }
}

//struct PlaygroundGraphView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaygroundGraphView()
//    }
//}









