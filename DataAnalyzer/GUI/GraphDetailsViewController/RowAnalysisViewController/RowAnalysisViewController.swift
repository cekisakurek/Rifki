//
//  RowAnalysisViewController.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 05.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit
import CoreData
import Charts

class RowAnalysisViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView: UITableView!
    private var columnDescriptionView : RowAnalysisDescriptionView!

    private var distributionGraphView: DistributionGraphView!
    private var probabilityGraphView: ProbabilityGraphView!
    
    private var appTheme = AppTheme()
    
    var calculationQueue = CalculationsOperationQueue()
    
    var histogramResult: HistorgramResult?
    var probabilityResult: ProbabilityResult?
    
    var dataset: GraphRawData? {
        didSet {

            self.histogramResult = nil
            self.probabilityResult = nil
            
            if let contentView = self.contentView {
                contentView.isHidden = dataset == nil
            }
            
            if let tableView = self.tableView {
                tableView.reloadData()
                redrawHistogramGraph()
                redrawProbabilityGraph()
            }
        }
    }
    
    private var settings: Settings!
    
    private var contentView: UIView!
    
    override func loadView() {
        super.loadView()
        
        self.contentView = UIView(frame: .zero)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.isHidden = true
        self.view.addSubview(self.contentView)
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.contentView.addSubview(tableView)
        
        let tableSeparatorView = UIView(frame: .zero)
        tableSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        tableSeparatorView.backgroundColor = UIColor.lightGray
        self.contentView.addSubview(tableSeparatorView)

        columnDescriptionView = RowAnalysisDescriptionView(frame: .zero)
        columnDescriptionView.backgroundColor = UIColor.white
        columnDescriptionView.translatesAutoresizingMaskIntoConstraints = false

        self.distributionGraphView = DistributionGraphView(frame: .zero)
        self.probabilityGraphView = ProbabilityGraphView(frame: .zero)
        
        let stackView = UIStackView(arrangedSubviews: [self.distributionGraphView, self.probabilityGraphView, columnDescriptionView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 24.0
        
        self.contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            self.contentView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            
            self.tableView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.tableView.widthAnchor.constraint(equalToConstant: 350.0),
            
            tableSeparatorView.topAnchor.constraint(equalTo: self.tableView.topAnchor),
            tableSeparatorView.leadingAnchor.constraint(equalTo: self.tableView.trailingAnchor),
            tableSeparatorView.bottomAnchor.constraint(equalTo: self.tableView.bottomAnchor),
            tableSeparatorView.widthAnchor.constraint(equalToConstant: 2.0),
            
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8.0),
            stackView.leadingAnchor.constraint(equalTo: tableSeparatorView.trailingAnchor, constant: 8.0),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 8.0),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8.0)
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadGraphs), name: NSNotification.Name(rawValue: "SettingsChanged"), object: nil)
        updateTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.dataset != nil {
            self.contentView.isHidden = false
        }
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
        
        var columnName = dataset!.headers?[r]
        
        
        switch dataset?.typeOfColumn(columnIndex: r) {
            case .Number:
                columnName! += " (" + NSLocalizedString("Number", comment: "") + ")"
                break
            case .DateTime:
                columnName! += " (" + NSLocalizedString("DateTime", comment: "") + ")"
                break
            case .String:
                columnName! += " (" + NSLocalizedString("String", comment: "") + ")"
                break
            case .Id:
                columnName! += " (" + NSLocalizedString("Id", comment: "") + ")"
                break
            case .Unknown:
                columnName! += " (" + NSLocalizedString("Unknown", comment: "") + ")"
                break
            default: break
        }
        
        cell.textLabel?.text = columnName
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let r = indexPath.row
        
        let (data, type) = (dataset?.column(atIndex: r))!
        
        
        
        if type == .Number {
            self.calculationQueue.calculateDistribution(data as! [Double], indexPath: indexPath) {
                [weak self]
                (results, indexPath, error) in
                
                guard let self = self else {
                    return
                }
                self.histogramResult = results
                self.redrawHistogramGraph()
                
                let p = results!.p
                let w = results!.w
                let g = results!.isGaussian
                
                self.columnDescriptionView.setData(data, type: type, p: p, w: w, isGaussian: g)
            }
            
            self.calculationQueue.calculateProbabilityDistribution(data as! [Double], indexPath: indexPath) {
                (results, indexPath, error) in
                
                self.probabilityResult = results
                self.redrawProbabilityGraph()
            }
        }
        else {
            self.histogramResult = nil
            self.probabilityResult = nil
            self.redrawHistogramGraph()
            self.redrawProbabilityGraph()
        }
    }

    func redrawHistogramGraph() {
        if let dataSet = self.histogramResult {
            
            let histogramDataSet = BarChartDataSet(entries: dataSet.histogramEntries)
            
            histogramDataSet.drawValuesEnabled = false
            histogramDataSet.axisDependency = .right
            histogramDataSet.colors = [self.distributionGraphView.theme.barColor]
            
            let histogramData = BarChartData(dataSets: [histogramDataSet])
            histogramData.barWidth = dataSet.width
            
            let frequenciesDataSet = LineChartDataSet(entries: dataSet.frequencies, label: NSLocalizedString("Frequency", comment: ""))
            frequenciesDataSet.colors = [self.distributionGraphView.theme.frequencyLineColor]
            frequenciesDataSet.mode = .cubicBezier
            frequenciesDataSet.drawCirclesEnabled = false
            frequenciesDataSet.lineWidth = self.distributionGraphView.theme.frequencyLineWidth
            frequenciesDataSet.axisDependency = .left
            
            let normalDataSet = LineChartDataSet(entries: dataSet.normal)
            normalDataSet.colors = [self.distributionGraphView.theme.normalLineColor]
            normalDataSet.mode = .cubicBezier
            normalDataSet.drawCirclesEnabled = false
            normalDataSet.lineWidth = self.distributionGraphView.theme.normalLineWidth
            normalDataSet.axisDependency = .left
            
            
            let combined = CombinedChartData()
            combined.lineData = LineChartData(dataSets: [frequenciesDataSet, normalDataSet])
            combined.barData = histogramData
            
            self.distributionGraphView.setData(combined)
            
        }
        else {
            self.distributionGraphView.setData(nil)
        }
    }
    
    func redrawProbabilityGraph() {
        if let dataSet = self.probabilityResult {
            
            let normalDataSet = LineChartDataSet(entries: dataSet.normal)
            normalDataSet.colors = [self.probabilityGraphView.theme.normalLineColor]
            normalDataSet.mode = .linear
            normalDataSet.drawCirclesEnabled = false
            normalDataSet.lineWidth = self.probabilityGraphView.theme.normalLineWidth
            
            let chartDataSet = ScatterChartDataSet(entries: dataSet.probabilities)
            chartDataSet.drawValuesEnabled = false
            chartDataSet.setScatterShape(.circle)
            chartDataSet.colors = [self.probabilityGraphView.theme.circleColor]
            
            let combined = CombinedChartData()
            combined.lineData = LineChartData(dataSet: normalDataSet)
            combined.scatterData = ScatterChartData(dataSets: [chartDataSet])
            
            self.probabilityGraphView.setData(combined)
        }
        else {
            self.probabilityGraphView.setData(nil)
        }
    }
    
    func updateTheme() {
        do {
            let context = CoreDataController.shared.writeContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
            let settings = try context.fetch(fetchRequest) as! [Settings]
            if let settingsObject = settings.first {
                self.distributionGraphView.theme.xAxisTextColor = settingsObject.dgXAxisTextColor as! UIColor
                self.distributionGraphView.theme.yAxisTextColor = settingsObject.dgYAxisTextColor as! UIColor
                self.distributionGraphView.theme.backgroundColor = settingsObject.dgBackgroundColor as! UIColor
                self.distributionGraphView.theme.normalLineWidth = CGFloat(settingsObject.dgNormalLineWidth)
                self.distributionGraphView.theme.normalLineColor = settingsObject.dgNormalLineColor as! UIColor
                self.distributionGraphView.theme.frequencyLineWidth = CGFloat(settingsObject.dgFrequencyLineWidth)
                self.distributionGraphView.theme.frequencyLineColor = settingsObject.dgFrequencyLineColor as! UIColor
                self.distributionGraphView.theme.barColor = settingsObject.dgBarColor as! UIColor
                self.distributionGraphView.updateGraph()
                
                self.probabilityGraphView.theme.yAxisTextColor = settingsObject.pgYAxisTextColor as! UIColor
                self.probabilityGraphView.theme.xAxisTextColor = settingsObject.pgXAxisTextColor as! UIColor
                self.probabilityGraphView.theme.normalLineWidth = CGFloat(settingsObject.pgNormalLineWidth)
                self.probabilityGraphView.theme.normalLineColor = settingsObject.pgNormalLineColor as! UIColor
                self.probabilityGraphView.theme.circleColor = settingsObject.pgCircleColor as! UIColor
                self.probabilityGraphView.theme.backgroundColor = settingsObject.pgBackgroundColor as! UIColor
                
                self.probabilityGraphView.updateGraph()
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
}
