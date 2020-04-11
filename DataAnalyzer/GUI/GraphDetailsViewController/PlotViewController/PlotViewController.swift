//
//  PlotViewController.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 01.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit

class PlotViewController: UIViewController {
    
    var barPlotView: BarPlotView!

    
    
    var graph: GraphData? {
        didSet {
            drawPoints()
        }
    }
    
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.lightGray
        
        barPlotView = BarPlotView(frame: .zero)
        barPlotView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(barPlotView)
        
        let defaultConstraints = [
            barPlotView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            barPlotView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            barPlotView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            barPlotView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(defaultConstraints)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        drawPoints()
        
    }
    
    func drawPoints() {
        
//        guard let barPlotView = barPlotView else {
//            return
//        }
        
        
//        if let graph = self.graph {
//
//            var dataPoints = [BarDataPoint]()
//
//            for i in 1..<graph.items!.count {
//                let row = graph.items![i] as? GraphRow
//
//                if let xCol = row!.columns![5] as? GraphColumn,
//                    let value = xCol.value,
//                    let xValue = Double(value),
//                    let yCol = row!.columns![0] as? GraphColumn,
//                    let yVal = yCol.value {
//
//                    if xValue > 5000 {
//                        let xPoint = PointDoubleValue(value: xValue, label: "Price")
//                        let yPoint = PointStringValue(value: yVal, label: "Date")
//
//                        let point = BarDataPoint(x: xPoint, y: yPoint)
//                        dataPoints.append(point)
//                    }
//
//
//                }
//            }
//            barPlotView.setData(points: dataPoints)
//        }
    }
}
