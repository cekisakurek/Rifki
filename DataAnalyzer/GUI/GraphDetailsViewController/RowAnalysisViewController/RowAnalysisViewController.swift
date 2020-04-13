//
//  RowAnalysisViewController.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 05.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit
import CoreData

class ChartsFormatterBlank: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return ""
    }
    
}

class RowAnalysisViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChartViewDelegate {
    
    private var tableView: UITableView!
    private var columnDescriptionView : RowAnalysisDescriptionView!
    private var distributionGraphView: CombinedChartView!
    private var probabilityPlotView: CombinedChartView!
    
    var distributionGraphTheme = DistributionGraphTheme()
    var probabilityGraphTheme = ProbabilityGraphTheme()
    
    var calculationQueue = CalculationsOperationQueue()
    
    var histogramResult: HistorgramResult?
    var probabilityResult: ProbabilityResult?
    
    
    var dataset: GraphRawData? {
        didSet {

            if let tableView = self.tableView {
                tableView.reloadData()
            }
        }
    }
    
    func updateProbabilityChart() {
        
        probabilityPlotLeftAxisTitleLabel.textColor = probabilityGraphTheme.yAxisTextColor
        probabilityPlotXAxisTitleLabel.textColor = probabilityGraphTheme.xAxisTextColor
        
        probabilityPlotView.delegate = self
        probabilityPlotView.legend.enabled = false
        probabilityPlotView.backgroundColor = probabilityGraphTheme.backgroundColor
        let xAxis = probabilityPlotView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = probabilityGraphTheme.xAxisTextColor
        
        probabilityPlotView.autoScaleMinMaxEnabled = false
        
        probabilityPlotView.xAxis.gridColor = .clear
        probabilityPlotView.leftAxis.gridColor = .clear
        probabilityPlotView.rightAxis.gridColor = .clear
        
        probabilityPlotView.leftAxis.labelTextColor = probabilityGraphTheme.yAxisTextColor
        probabilityPlotView.rightAxis.labelTextColor = probabilityGraphTheme.yAxisTextColor
        probabilityPlotView.isUserInteractionEnabled = false
                
        probabilityPlotView.noDataTextColor = probabilityGraphTheme.yAxisTextColor
        probabilityPlotView.noDataText = NSLocalizedString("No chart data available.", comment: "")
    }
    
    
    func updateDistributionGraph() {
        
        distributionPlotLeftAxisTitleLabel.textColor = distributionGraphTheme.yAxisTextColor
        distributionPlotXAxisTitleLabel.textColor = distributionGraphTheme.xAxisTextColor
        
        distributionGraphView.noDataTextColor = distributionGraphTheme.yAxisTextColor
        distributionGraphView.noDataText = NSLocalizedString("No chart data available.", comment: "")
//        let chartsFormatterBlank = ChartsFormatterBlank()
        distributionGraphView.isUserInteractionEnabled = false
        distributionGraphView.delegate = self
        distributionGraphView.legend.enabled = false
        distributionGraphView.backgroundColor = distributionGraphTheme.backgroundColor
        let xAxis = distributionGraphView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = distributionGraphTheme.xAxisTextColor
        
        distributionGraphView.leftAxis.labelTextColor = distributionGraphTheme.yAxisTextColor
        distributionGraphView.rightAxis.labelTextColor = distributionGraphTheme.yAxisTextColor
        
        distributionGraphView.rightAxis.axisMinimum = 0.0
        
        distributionGraphView.xAxis.gridColor = .clear
        distributionGraphView.leftAxis.gridColor = .clear
        distributionGraphView.rightAxis.gridColor = .clear
        
        distributionGraphView.notifyDataSetChanged()
        distributionGraphView.setNeedsDisplay()

    }
    
    var distributionPlotLeftAxisTitleLabel: UILabel!
    var distributionPlotXAxisTitleLabel: UILabel!
    
    var probabilityPlotLeftAxisTitleLabel: UILabel!
    var probabilityPlotXAxisTitleLabel: UILabel!
    
    private var settings: Settings!
    
    func updateTheme() {
        do {
            let context = CoreDataController.shared.managedObjectContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
            let settings = try context!.fetch(fetchRequest) as! [Settings]
            if let settingsObject = settings.first {
                distributionGraphTheme.xAxisTextColor = settingsObject.dgXAxisTextColor as! UIColor
                distributionGraphTheme.yAxisTextColor = settingsObject.dgYAxisTextColor as! UIColor
                distributionGraphTheme.backgroundColor = settingsObject.dgBackgroundColor as! UIColor
                distributionGraphTheme.normalLineWidth = CGFloat(settingsObject.dgNormalLineWidth)
                distributionGraphTheme.normalLineColor = settingsObject.dgNormalLineColor as! UIColor
                distributionGraphTheme.frequencyLineWidth = CGFloat(settingsObject.dgFrequencyLineWidth)
                distributionGraphTheme.frequencyLineColor = settingsObject.dgFrequencyLineColor as! UIColor
                distributionGraphTheme.barColor = settingsObject.dgBarColor as! UIColor
                
                probabilityGraphTheme.yAxisTextColor = settingsObject.pgYAxisTextColor as! UIColor
                probabilityGraphTheme.xAxisTextColor = settingsObject.pgXAxisTextColor as! UIColor
                probabilityGraphTheme.normalLineWidth = CGFloat(settingsObject.pgNormalLineWidth)
                probabilityGraphTheme.normalLineColor = settingsObject.pgNormalLineColor as! UIColor
                probabilityGraphTheme.circleColor = settingsObject.pgCircleColor as! UIColor
                probabilityGraphTheme.backgroundColor = settingsObject.pgBackgroundColor as! UIColor
            }
        }
        catch {
            ErrorAlertView.showError(with: String(describing: error), from: self)
        }
    }
    
    @objc func reloadGraphs() {
        updateTheme()
        redrawHistogramGraph()
        redrawProbabilityGraph()
    }
    
    override func loadView() {
        super.loadView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadGraphs), name: NSNotification.Name(rawValue: "SettingsChanged"), object: nil)
        updateTheme()
        
        let axisLabelFonts = UIFont.systemFont(ofSize: 13.0)
        let plotTitleFont = UIFont.boldSystemFont(ofSize: 16.0)
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(tableView)
        
        let plotContainerView = UIView(frame: .zero)
        plotContainerView.translatesAutoresizingMaskIntoConstraints = false
        plotContainerView.backgroundColor = UIColor.white
        self.view.addSubview(plotContainerView)
        
        let tableSeparatorView = UIView(frame: .zero)
        tableSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        tableSeparatorView.backgroundColor = UIColor.lightGray
        self.view.addSubview(tableSeparatorView)
        
        columnDescriptionView = RowAnalysisDescriptionView(frame: .zero)
        columnDescriptionView.backgroundColor = UIColor.white
        columnDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        plotContainerView.addSubview(columnDescriptionView)
        
        let distributionPlotTitleLabel = UILabel(frame: .zero)
        distributionPlotTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        distributionPlotTitleLabel.font = plotTitleFont
        distributionPlotTitleLabel.textColor = UIColor.black
        distributionPlotTitleLabel.textAlignment = .center
        distributionPlotTitleLabel.text = NSLocalizedString("Distribution", comment: "")
        plotContainerView.addSubview(distributionPlotTitleLabel)
        
        distributionPlotLeftAxisTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100.0, height: 20.0))
        distributionPlotLeftAxisTitleLabel.font = axisLabelFonts
        distributionPlotLeftAxisTitleLabel.textColor = distributionGraphTheme.yAxisTextColor
        distributionPlotLeftAxisTitleLabel.textAlignment = .center
        distributionPlotLeftAxisTitleLabel.text = NSLocalizedString("Frequency", comment: "")
        distributionPlotLeftAxisTitleLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        plotContainerView.addSubview(distributionPlotLeftAxisTitleLabel)
        
        distributionPlotXAxisTitleLabel = UILabel(frame: .zero)
        distributionPlotXAxisTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        distributionPlotXAxisTitleLabel.font = axisLabelFonts
        distributionPlotXAxisTitleLabel.textColor = distributionGraphTheme.xAxisTextColor
        distributionPlotXAxisTitleLabel.textAlignment = .center
        distributionPlotXAxisTitleLabel.text = NSLocalizedString("Values", comment: "")
        plotContainerView.addSubview(distributionPlotXAxisTitleLabel)
        
        distributionGraphView = CombinedChartView(frame: .zero)
        distributionGraphView.translatesAutoresizingMaskIntoConstraints = false
        updateDistributionGraph()
        plotContainerView.addSubview(distributionGraphView)

        let graphSeparatorView = UIView(frame: .zero)
        graphSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        graphSeparatorView.backgroundColor = UIColor.lightGray
        plotContainerView.addSubview(graphSeparatorView)
        
        let descriptionSeparatorView = UIView(frame: .zero)
        descriptionSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        descriptionSeparatorView.backgroundColor = UIColor.lightGray
        plotContainerView.addSubview(descriptionSeparatorView)
        
        let probabilityPlotTitleLabel = UILabel(frame: .zero)
        probabilityPlotTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        probabilityPlotTitleLabel.font = plotTitleFont
        probabilityPlotTitleLabel.textColor = UIColor.black
        probabilityPlotTitleLabel.textAlignment = .center
        probabilityPlotTitleLabel.text = NSLocalizedString("Probability", comment: "")
        plotContainerView.addSubview(probabilityPlotTitleLabel)
        
        probabilityPlotLeftAxisTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100.0, height: 20.0))
        probabilityPlotLeftAxisTitleLabel.font = axisLabelFonts
        probabilityPlotLeftAxisTitleLabel.textColor = probabilityGraphTheme.yAxisTextColor
        probabilityPlotLeftAxisTitleLabel.textAlignment = .center
        probabilityPlotLeftAxisTitleLabel.text = NSLocalizedString("Ordered Values", comment: "")
        probabilityPlotLeftAxisTitleLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        plotContainerView.addSubview(probabilityPlotLeftAxisTitleLabel)
        
        probabilityPlotXAxisTitleLabel = UILabel(frame: .zero)
        probabilityPlotXAxisTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        probabilityPlotXAxisTitleLabel.font = axisLabelFonts
        probabilityPlotXAxisTitleLabel.textColor = probabilityGraphTheme.xAxisTextColor
        probabilityPlotXAxisTitleLabel.textAlignment = .center
        probabilityPlotXAxisTitleLabel.text = NSLocalizedString("Theoretical quantiles", comment: "")
        plotContainerView.addSubview(probabilityPlotXAxisTitleLabel)
        
        probabilityPlotView = CombinedChartView(frame: .zero)
        probabilityPlotView.translatesAutoresizingMaskIntoConstraints = false
        updateProbabilityChart()
        plotContainerView.addSubview(probabilityPlotView)
        
        let plotMargins = CGFloat(50.0)
        let interGraphDistance = CGFloat(50.0)
        let xAxisLabelMargin = CGFloat(8.0)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tableView.widthAnchor.constraint(equalToConstant: 350.0),
            
            tableSeparatorView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableSeparatorView.leadingAnchor.constraint(equalTo: tableView.trailingAnchor),
            tableSeparatorView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tableSeparatorView.widthAnchor.constraint(equalToConstant: 2.0),
            tableSeparatorView.trailingAnchor.constraint(equalTo: plotContainerView.leadingAnchor),
            
            
            plotContainerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            plotContainerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            plotContainerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            
            
            distributionPlotTitleLabel.topAnchor.constraint(equalTo: plotContainerView.topAnchor, constant: interGraphDistance/2.0),
            distributionPlotTitleLabel.leadingAnchor.constraint(equalTo: plotContainerView.leadingAnchor),
            distributionPlotTitleLabel.trailingAnchor.constraint(equalTo: plotContainerView.trailingAnchor),
            distributionPlotTitleLabel.bottomAnchor.constraint(equalTo: distributionGraphView.topAnchor),
            distributionPlotTitleLabel.heightAnchor.constraint(equalToConstant: 30.0),
            
            distributionGraphView.topAnchor.constraint(equalTo: distributionPlotTitleLabel.bottomAnchor),
            distributionGraphView.leadingAnchor.constraint(equalTo: plotContainerView.leadingAnchor, constant: plotMargins),
            distributionGraphView.trailingAnchor.constraint(equalTo: plotContainerView.trailingAnchor, constant: -plotMargins),
            distributionGraphView.heightAnchor.constraint(equalToConstant: 300),
            
            distributionPlotXAxisTitleLabel.topAnchor.constraint(equalTo: distributionGraphView.bottomAnchor, constant: xAxisLabelMargin),
            distributionPlotXAxisTitleLabel.leadingAnchor.constraint(equalTo: distributionGraphView.leadingAnchor),
            distributionPlotXAxisTitleLabel.trailingAnchor.constraint(equalTo: distributionGraphView.trailingAnchor),
            
            graphSeparatorView.topAnchor.constraint(equalTo: distributionPlotXAxisTitleLabel.bottomAnchor, constant: interGraphDistance/2.0),
            graphSeparatorView.leadingAnchor.constraint(equalTo: plotContainerView.leadingAnchor),
            graphSeparatorView.bottomAnchor.constraint(equalTo: probabilityPlotTitleLabel.topAnchor, constant: -interGraphDistance/2.0),
            graphSeparatorView.trailingAnchor.constraint(equalTo: plotContainerView.trailingAnchor),
            graphSeparatorView.heightAnchor.constraint(equalToConstant: 1.0),
            
            
            probabilityPlotTitleLabel.leadingAnchor.constraint(equalTo: plotContainerView.leadingAnchor),
            probabilityPlotTitleLabel.trailingAnchor.constraint(equalTo: plotContainerView.trailingAnchor),
            probabilityPlotTitleLabel.bottomAnchor.constraint(equalTo: probabilityPlotView.topAnchor),
            probabilityPlotTitleLabel.heightAnchor.constraint(equalToConstant: 30.0),
            
            probabilityPlotView.leadingAnchor.constraint(equalTo: plotContainerView.leadingAnchor, constant: plotMargins),
            probabilityPlotView.trailingAnchor.constraint(equalTo: plotContainerView.trailingAnchor, constant: -plotMargins),
            probabilityPlotView.heightAnchor.constraint(equalToConstant: 300),
            
            
            probabilityPlotXAxisTitleLabel.topAnchor.constraint(equalTo: probabilityPlotView.bottomAnchor, constant: xAxisLabelMargin),
            probabilityPlotXAxisTitleLabel.leadingAnchor.constraint(equalTo: probabilityPlotView.leadingAnchor),
            probabilityPlotXAxisTitleLabel.trailingAnchor.constraint(equalTo: probabilityPlotView.trailingAnchor),
            
            descriptionSeparatorView.topAnchor.constraint(equalTo: probabilityPlotXAxisTitleLabel.bottomAnchor, constant: interGraphDistance/2.0),
            descriptionSeparatorView.leadingAnchor.constraint(equalTo: plotContainerView.leadingAnchor),
            descriptionSeparatorView.bottomAnchor.constraint(equalTo: columnDescriptionView.topAnchor, constant: -interGraphDistance/2.0),
            descriptionSeparatorView.trailingAnchor.constraint(equalTo: plotContainerView.trailingAnchor),
            descriptionSeparatorView.heightAnchor.constraint(equalToConstant: 1.0),
            
            columnDescriptionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            columnDescriptionView.centerXAnchor.constraint(equalTo: plotContainerView.centerXAnchor),
            columnDescriptionView.widthAnchor.constraint(equalToConstant: 300.0),
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        distributionPlotLeftAxisTitleLabel.frame = CGRect(x: distributionGraphView.frame.origin.x - 20.0,
                                                          y: distributionGraphView.frame.origin.y + 100.0,
                                                          width: distributionPlotLeftAxisTitleLabel.frame.size.width, height: distributionPlotLeftAxisTitleLabel.frame.height)
                
        
        
        probabilityPlotLeftAxisTitleLabel.frame = CGRect(x: probabilityPlotView.frame.origin.x - 20.0,
                                                         y: probabilityPlotView.frame.origin.y + 100.0,
                                                         width: probabilityPlotLeftAxisTitleLabel.frame.size.width, height: probabilityPlotLeftAxisTitleLabel.frame.height)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("Columns", comment: "")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = dataset {
            return data.headers!.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let r = indexPath.row
        
        let columnName = dataset!.headers?[r]
        cell.textLabel?.text = columnName
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let r = indexPath.row
        
        let (data, type) = (dataset?.column(atIndex: r))!
        
        columnDescriptionView.setData(data, type: type)
        
        self.calculationQueue.calculateDistribution(data as! [Double], indexPath: indexPath) {
            [weak self]
            (results, indexPath, error) in
            
            guard let self = self else {
                return
            }
            self.histogramResult = results
            self.redrawHistogramGraph()
        }
        
        self.calculationQueue.calculateProbabilityDistribution(data as! [Double], indexPath: indexPath) {
            (results, indexPath, error) in
            
            self.probabilityResult = results
            self.redrawProbabilityGraph()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    
    func redrawHistogramGraph() {
        updateDistributionGraph()
        if let dataSet = self.histogramResult {
            
            let histogramDataSet = BarChartDataSet(entries: dataSet.histogramEntries)
            
            histogramDataSet.drawValuesEnabled = false
            histogramDataSet.axisDependency = .right
            histogramDataSet.colors = [self.distributionGraphTheme.barColor]
            
            let histogramData = BarChartData(dataSets: [histogramDataSet])
            histogramData.barWidth = dataSet.width
            
            let frequenciesDataSet = LineChartDataSet(entries: dataSet.frequencies, label: NSLocalizedString("Frequency", comment: ""))
            frequenciesDataSet.colors = [self.distributionGraphTheme.frequencyLineColor]
            frequenciesDataSet.mode = .cubicBezier
            frequenciesDataSet.drawCirclesEnabled = false
            frequenciesDataSet.lineWidth = self.distributionGraphTheme.frequencyLineWidth
            frequenciesDataSet.axisDependency = .left
            
            let normalDataSet = LineChartDataSet(entries: dataSet.normal)
            normalDataSet.colors = [self.distributionGraphTheme.normalLineColor]
            normalDataSet.mode = .cubicBezier
            normalDataSet.drawCirclesEnabled = false
            normalDataSet.lineWidth = self.distributionGraphTheme.normalLineWidth
            normalDataSet.axisDependency = .left
            
            
            let combined = CombinedChartData()
            combined.lineData = LineChartData(dataSets: [frequenciesDataSet, normalDataSet])
            combined.barData = histogramData
            
            self.distributionGraphView.data = combined
            self.distributionGraphView.animate(xAxisDuration: 0.25, yAxisDuration: 0.25)
        }
        else {
            self.distributionGraphView.data = nil
            self.distributionGraphView.animate(xAxisDuration: 0.25, yAxisDuration: 0.25)
        }
    }
    
    func redrawProbabilityGraph() {
        updateProbabilityChart()
        if let dataSet = self.probabilityResult {
            
            let normalDataSet = LineChartDataSet(entries: dataSet.normal)
            normalDataSet.colors = [probabilityGraphTheme.normalLineColor]
            normalDataSet.mode = .linear
            normalDataSet.drawCirclesEnabled = false
            normalDataSet.lineWidth = probabilityGraphTheme.normalLineWidth
            
            let chartDataSet = ScatterChartDataSet(entries: dataSet.probabilities)
            chartDataSet.drawValuesEnabled = false
            chartDataSet.setScatterShape(.circle)
            chartDataSet.colors = [probabilityGraphTheme.circleColor]
            
            let combined = CombinedChartData()
            combined.lineData = LineChartData(dataSet: normalDataSet)
            combined.scatterData = ScatterChartData(dataSets: [chartDataSet])
            
            self.probabilityPlotView.data = combined
            self.probabilityPlotView.animate(xAxisDuration: 0.25, yAxisDuration: 0.25, easingOption: .easeInOutCirc)
            
            
        }
        else {
            self.probabilityPlotView.data = nil
            self.probabilityPlotView.animate(xAxisDuration: 0.25, yAxisDuration: 0.25)
        }
    }
}
