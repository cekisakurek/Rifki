//
//  PlaygroundGraphViewController.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 29.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit
import Charts

class PlaygroundGraphViewController: UIViewController, ChartViewDelegate, UIDocumentPickerDelegate {
    
    var dataset: GraphRawData?
    var graph: Graph?
    
    private var graphView: CombinedChartView!
    
    private var plotTitleLabel: UILabel!
    
    var leftAxisTitleLabel: UILabel!
    var bottomAxisTitleLabel: UILabel!
    
    func shareAsImage(sender: UIBarButtonItem) {
        
        let renderer = UIGraphicsImageRenderer(bounds: self.view.bounds)
        let image = renderer.image { rendererContext in
            self.view.layer.render(in: rendererContext.cgContext)
        }
        
        let imageShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = sender
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func saveAsImage(sender: UIBarButtonItem) {
        
        let renderer = UIGraphicsImageRenderer(bounds: self.view.bounds)
        let image = renderer.image { rendererContext in
            self.view.layer.render(in: rendererContext.cgContext)
        }
        
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        
        if let data = image.jpegData(compressionQuality: 1.0) {
            let uuid = UUID().uuidString
            let name = uuid + ".jpg"
            let filename = paths.appendingPathComponent(name)
            try? data.write(to: filename)
            let controller = UIDocumentPickerViewController(url: filename, in: UIDocumentPickerMode.exportToService)
            controller.delegate = self
            self.navigationController!.present(controller, animated: true)
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
    }
    
    @objc func presentActions(sender: UIBarButtonItem) {
        
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive) {
            [weak self] (action) in
            
            do {
                try self?.graph?.delete()
                self?.navigationController?.popViewController(animated: true)
            }
            catch {
                ErrorAlertView.showError(with: String(describing: error), from: self!)
            }
        }
        let saveAction = UIAlertAction(title: NSLocalizedString("Export", comment: ""), style: .default) {
            [weak self] (action) in
            self?.saveAsImage(sender: sender)
            
        }
        let shareAction = UIAlertAction(title: NSLocalizedString("Share", comment: ""), style: .default) {
            [weak self] (action) in
            self?.shareAsImage(sender: sender)
            
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { (action) in
        }
        
        controller.addAction(saveAction)
        controller.addAction(shareAction)
        controller.addAction(deleteAction)
        controller.addAction(cancelAction)
        
        if let popoverController = controller.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        
        self.navigationController?.present(controller, animated: true, completion: {
            
        })
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.white
        
        let exportItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(presentActions))
        
        self.navigationItem.rightBarButtonItem = exportItem
        
        plotTitleLabel = UILabel(frame: .zero)
        plotTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        plotTitleLabel.textAlignment = .center
        
        self.view.addSubview(plotTitleLabel)
        
        leftAxisTitleLabel = UILabel(frame: CGRect(x: 0, y: 0.0, width: self.view.bounds.size.height, height: 50.0))
        leftAxisTitleLabel.textAlignment = .center
        leftAxisTitleLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        self.view.addSubview(leftAxisTitleLabel)
        
        bottomAxisTitleLabel = UILabel(frame: .zero)
        bottomAxisTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomAxisTitleLabel.textAlignment = .center
        self.view.addSubview(bottomAxisTitleLabel)
        
        graphView = CombinedChartView(frame: .zero)
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.delegate = self
        graphView.legend.enabled = false
        graphView.backgroundColor = UIColor.white
        
        graphView.xAxis.labelPosition = .bottom
        
        graphView.autoScaleMinMaxEnabled = false
        
        graphView.xAxis.gridColor = .clear
        graphView.leftAxis.gridColor = .clear
        graphView.rightAxis.gridColor = .clear
        
        graphView.noDataTextColor = UIColor.black
        graphView.noDataText = NSLocalizedString("No chart data available.", comment: "")
        self.view.addSubview(graphView)
        
        let leftMargin = CGFloat(50.0)
        let rightMargin = CGFloat(50.0)
        let titleMargin = CGFloat(50.0)
        let titleTopMargin = CGFloat(40.0)
        let plotBottomMargin = CGFloat(40.0)
        
        NSLayoutConstraint.activate([
            plotTitleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: titleTopMargin),
            plotTitleLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: leftMargin),
            plotTitleLabel.bottomAnchor.constraint(equalTo: graphView.topAnchor, constant: -titleMargin),
            plotTitleLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -rightMargin),
            
            graphView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: leftMargin),
            graphView.bottomAnchor.constraint(equalTo: bottomAxisTitleLabel.topAnchor),
            graphView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -rightMargin),
            
            bottomAxisTitleLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: leftMargin),
            bottomAxisTitleLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -plotBottomMargin),
            bottomAxisTitleLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -rightMargin),
            bottomAxisTitleLabel.heightAnchor.constraint(equalToConstant: 50.0)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        leftAxisTitleLabel.frame = CGRect(x: 0.0,
                                          y: graphView.frame.origin.y,
                                          width: leftAxisTitleLabel.frame.size.width, height: graphView.frame.height)
    }
    
    func fontWithName(_ name: String, size: CGFloat) -> UIFont {
        
        if name == systemFontName {
            return UIFont.systemFont(ofSize: size)
        }
        else if name == systemBoldFontName {
            return UIFont.boldSystemFont(ofSize: size)
        }
        else if let selectedFont = UIFont(name: name, size: size) {
            return selectedFont
        }
        else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let graph = graph {
            
            graphView.backgroundColor = graph.backgroundColor as? UIColor
            
            plotTitleLabel.text = graph.name
            plotTitleLabel.font = self.fontWithName(graph.titleFontName!, size: CGFloat(graph.titleFontSize)) // 100.0
            plotTitleLabel.textColor = graph.titleColor as? UIColor
            
            leftAxisTitleLabel.text = graph.yAxisName
            leftAxisTitleLabel.font = self.fontWithName(graph.yAxisTextFontName!, size: CGFloat(graph.yAxisTextFontSize)) // 50.0
            leftAxisTitleLabel.textColor = graph.yAxisTextColor as? UIColor
            
            bottomAxisTitleLabel.text = graph.xAxisName
            bottomAxisTitleLabel.font = self.fontWithName(graph.xAxisTextFontName!, size: CGFloat(graph.xAxisTextFontSize)) // 50.0
            bottomAxisTitleLabel.textColor = graph.xAxisTextColor as? UIColor
            
            
            let leftAxisFont = self.fontWithName(graph.yAxisTextFontName!, size: CGFloat(graph.yAxisTextFontSize - 5.0))
            let bottomAxisFont = self.fontWithName(graph.xAxisTextFontName!, size: CGFloat(graph.xAxisTextFontSize - 5.0))
            
            graphView.leftAxis.labelTextColor = graph.yAxisTextColor as? UIColor ?? UIColor.black
            graphView.leftAxis.labelFont = leftAxisFont
            graphView.rightAxis.labelTextColor = graph.yAxisTextColor as? UIColor ?? UIColor.black
            graphView.rightAxis.labelFont = leftAxisFont
            
            graphView.xAxis.labelTextColor = graph.xAxisTextColor as? UIColor ?? UIColor.black
            graphView.xAxis.labelFont = bottomAxisFont
        }
        
        for graphData in graph!.data!  {
            
            if let d = graphData as? GraphData {
                let xAxis = d.xAxis!
                let yAxis = d.yAxis!
                
                let (xColumn, _) = dataset!.column(named: xAxis)
                let (yColumn, _) = dataset!.column(named: yAxis)
                
                let xColumnAsDoubleArray = xColumn as! [Double]
                
                if graph!.type == "Line" {
                    
                    var entries = [ChartDataEntry]()
                    for i in 0..<xColumnAsDoubleArray.count {
                        
                        let entry = ChartDataEntry(x: xColumn![i] as! Double, y: yColumn![i] as! Double)
                        entries.append(entry)
                    }
                    entries.sort(by: { $0.x < $1.x })
                    
                    let lineColor = (d.lineColor as? UIColor ?? UIColor.black)
                    let lineWidth = d.lineWidth
                    
                    let chartDataSet = LineChartDataSet(entries: entries)
                    chartDataSet.colors = [lineColor]
                    chartDataSet.mode = .linear
                    chartDataSet.drawCirclesEnabled = false
                    chartDataSet.lineWidth = CGFloat(lineWidth)
                    
                    let combinedChart = CombinedChartData()
                    combinedChart.lineData = LineChartData(dataSet: chartDataSet)
                    self.graphView.data = combinedChart
                }
                else if graph!.type == "Bar" {
                    
                    var entries = [BarChartDataEntry]()
                    for i in 0..<xColumnAsDoubleArray.count {
                        
                        let entry = BarChartDataEntry(x: xColumn![i] as! Double, y: yColumn![i] as! Double)
                        entries.append(entry)
                    }
                    entries.sort(by: { $0.x < $1.x })
                    
                    let color = (d.barColor as? UIColor ?? UIColor.black)
                    
                    let chartDataSet = BarChartDataSet(entries: entries)
                    chartDataSet.colors = [color]
                    let combinedChart = CombinedChartData()
                    combinedChart.barData = BarChartData(dataSet: chartDataSet)
                    self.graphView.data = combinedChart
                }
                else if graph!.type == "Scatter" {
                    
                    var entries = [ChartDataEntry]()
                    for i in 0..<xColumnAsDoubleArray.count {
                        
                        let entry = ChartDataEntry(x: xColumn![i] as! Double, y: yColumn![i] as! Double)
                        entries.append(entry)
                    }
                    entries.sort(by: { $0.x < $1.x })
                    
                    let color = (d.circleColor as? UIColor ?? UIColor.black)
                    let circleSize = d.circleSize
                    
                    let chartDataSet = ScatterChartDataSet(entries: entries)
                    chartDataSet.drawValuesEnabled = false
                    chartDataSet.colors = [color]
                    chartDataSet.scatterShapeSize = CGFloat(circleSize)
                    chartDataSet.setScatterShape(.circle)
                    
                    let combinedChart = CombinedChartData()
                    combinedChart.scatterData = ScatterChartData(dataSet: chartDataSet)
                    self.graphView.data = combinedChart
                }
            }
        }
    }
}
