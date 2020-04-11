//
//  RowAnalysisViewController.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 05.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit

class ChartsFormatterBlank: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return ""
    }
    
}


class RowAnalysisViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChartViewDelegate {
    
    private var tableView: UITableView!
    private var columnDescriptionView : RowAnalysisDescriptionView!
    private var distributionPlotView: CombinedChartView!
//    private var distributionPlotView: BarPlotView!
//    private var probabilityPlotView: ScatterPlotView!
    private var probabilityPlotView: CombinedChartView!
    
    var calculationQueue = CalculationsOperationQueue()
    
    var dataset: GraphRawData? {
        didSet {

            if let tableView = self.tableView {
                tableView.reloadData()
            }
            
            
        }
    }
    
    
//    func roundTest() {
//
//        let number = 0.000007463
////        let number = 787000.0
//
//        let exponent = log10(number)
//
//        let mantissa = number / pow(10, exponent)
//
//        let digits = number / pow(10, ceil(exponent + 1))
//
//        let rounded = digits.roundedUp(toPlaces: 2)
//
//
//
//        let result = rounded * pow(10,ceil(exponent+1))
//
////        10^exp
//
////        let exponent = trunc(log(number) / log(10.0))
////
////        let mantissa = number / pow(10, trunc(log(number) / log(10.0)))
////
////        let result = pow(10.0, exponent) //+ mantissa
////        print(number)
////        print(result)
////        print("exp: " + String(exponent) + " mantissa: " + String(mantissa) + " number: " + String(result))
//
//
//
////        let r = mantissa.rounded(toPlaces: 2) * pow(10.0, exponent)
//    }
    
    func setupProbabilityChart() {
        probabilityPlotView.delegate = self
        probabilityPlotView.legend.enabled = false
        probabilityPlotView.backgroundColor = UIColor.white
        let xAxis = probabilityPlotView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = UIColor.black
        
        probabilityPlotView.autoScaleMinMaxEnabled = false
        
        probabilityPlotView.xAxis.gridColor = .clear
        probabilityPlotView.leftAxis.gridColor = .clear
        probabilityPlotView.rightAxis.gridColor = .clear
        
        probabilityPlotView.leftAxis.labelTextColor = UIColor.black
        probabilityPlotView.rightAxis.labelTextColor = UIColor.black
        probabilityPlotView.xAxis.labelTextColor = UIColor.black
        probabilityPlotView.isUserInteractionEnabled = false
        
//        probabilityPlotView.layer.borderColor = UIColor.lightGray.cgColor
//        probabilityPlotView.layer.borderWidth = 1.0
        
        probabilityPlotView.noDataTextColor = UIColor.black
        probabilityPlotView.noDataText = NSLocalizedString("No chart data available.", comment: "")
    }
    
    
    func setupChart(chartView: CombinedChartView) {
        
        chartView.noDataTextColor = UIColor.black
        chartView.noDataText = NSLocalizedString("No chart data available.", comment: "")
//        let chartsFormatterBlank = ChartsFormatterBlank()
        chartView.isUserInteractionEnabled = false
        chartView.delegate = self
        chartView.legend.enabled = false
        chartView.backgroundColor = UIColor.white
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = UIColor.black
        chartView.leftAxis.labelTextColor = UIColor.black
        chartView.rightAxis.labelTextColor = UIColor.black
        
        chartView.rightAxis.axisMinimum = 0.0
        

        chartView.xAxis.gridColor = .clear
        chartView.leftAxis.gridColor = .clear
        chartView.rightAxis.gridColor = .clear
        
        
//        chartView.layer.borderColor = UIColor.lightGray.cgColor
//        chartView.layer.borderWidth = 1.0
        
        
        chartView.animate(xAxisDuration: 0.5)
        chartView.animate(yAxisDuration: 0.5)
//        chartView.rightAxis.enabled = false
//        chartView.xAxis.valueFormatter = chartsFormatterBlank as! IAxisValueFormatter
        
//        chartView.autoScaleMinMaxEnabled = true
//        chartView.gridBackgroundColor = UIColor.white
//        chartView.drawValueAboveBarEnabled = false
//        chartView.drawBarShadowEnabled = false
//        chartView.drawValueAboveBarEnabled = false
//
//        chartView.maxVisibleCount = 60
//
//        let xAxis = chartView.xAxis
//        let yAxis = chartView.xAxis
//        xAxis.drawAxisLineEnabled = false
//        xAxis.drawGridLinesEnabled = false
//        xAxis.resetCustomAxisMax()
//        xAxis.customAxisMin = 0;
//        xAxis.customAxisMax = 1;
//        xAxis.labelPosition = .bottom
//        xAxis.labelFont = .systemFont(ofSize: 10)
//        xAxis.granularity = 1
//        xAxis.labelCount = 7
////        xAxis.valueFormatter = DayAxisValueFormatter(chart: chartView)
//
//
        
        chartView.notifyDataSetChanged()
        chartView.setNeedsDisplay()
//
//        let leftAxisFormatter = NumberFormatter()
//        leftAxisFormatter.minimumFractionDigits = 0
//        leftAxisFormatter.maximumFractionDigits = 1
//        leftAxisFormatter.negativeSuffix = " $"
//        leftAxisFormatter.positiveSuffix = " $"
//
//        let leftAxis = chartView.leftAxis
//        leftAxis.labelFont = .systemFont(ofSize: 10)
//        leftAxis.labelCount = 8
//        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
//        leftAxis.labelPosition = .outsideChart
//        leftAxis.spaceTop = 0.15
//        leftAxis.axisMinimum = 0 // FIXME: HUH?? this replaces startAtZero = YES
//
//        let rightAxis = chartView.rightAxis
//        rightAxis.enabled = true
//        rightAxis.labelFont = .systemFont(ofSize: 10)
//        rightAxis.labelCount = 8
//        rightAxis.valueFormatter = leftAxis.valueFormatter
//        rightAxis.spaceTop = 0.15
//        rightAxis.axisMinimum = 0
//
//        let l = chartView.legend
//        l.horizontalAlignment = .left
//        l.verticalAlignment = .bottom
//        l.orientation = .horizontal
//        l.drawInside = false
//        l.form = .circle
//        l.formSize = 9
//        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
//        l.xEntrySpace = 4
        //        chartView.legend = l
//
//        let marker = XYMarkerView(color: UIColor(white: 180/250, alpha: 1),
//                                  font: .systemFont(ofSize: 12),
//                                  textColor: .white,
//                                  insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8),
//                                  xAxisValueFormatter: chartView.xAxis.valueFormatter!)
//        marker.chartView = chartView
//        marker.minimumSize = CGSize(width: 80, height: 40)
//        chartView.marker = marker
    }
    
    var distributionPlotLeftAxisTitleLabel: UILabel!
    var distributionPlotXAxisTitleLabel: UILabel!
    
    var probabilityPlotLeftAxisTitleLabel: UILabel!
    var probabilityPlotXAxisTitleLabel: UILabel!
    
    override func loadView() {
        super.loadView()
        
        
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
        distributionPlotLeftAxisTitleLabel.textColor = UIColor.black
        distributionPlotLeftAxisTitleLabel.textAlignment = .center
        distributionPlotLeftAxisTitleLabel.text = NSLocalizedString("Frequency", comment: "")
        distributionPlotLeftAxisTitleLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        plotContainerView.addSubview(distributionPlotLeftAxisTitleLabel)
        
        distributionPlotXAxisTitleLabel = UILabel(frame: .zero)
        distributionPlotXAxisTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        distributionPlotXAxisTitleLabel.font = axisLabelFonts
        distributionPlotXAxisTitleLabel.textColor = UIColor.black
        distributionPlotXAxisTitleLabel.textAlignment = .center
        distributionPlotXAxisTitleLabel.text = NSLocalizedString("Values", comment: "")
        plotContainerView.addSubview(distributionPlotXAxisTitleLabel)
        
        distributionPlotView = CombinedChartView(frame: .zero)
        distributionPlotView.translatesAutoresizingMaskIntoConstraints = false
        setupChart(chartView: distributionPlotView)
        plotContainerView.addSubview(distributionPlotView)

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
        probabilityPlotLeftAxisTitleLabel.textColor = UIColor.black
        probabilityPlotLeftAxisTitleLabel.textAlignment = .center
        probabilityPlotLeftAxisTitleLabel.text = NSLocalizedString("Ordered Values", comment: "")
        probabilityPlotLeftAxisTitleLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        plotContainerView.addSubview(probabilityPlotLeftAxisTitleLabel)
        
        probabilityPlotXAxisTitleLabel = UILabel(frame: .zero)
        probabilityPlotXAxisTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        probabilityPlotXAxisTitleLabel.font = axisLabelFonts
        probabilityPlotXAxisTitleLabel.textColor = UIColor.black
        probabilityPlotXAxisTitleLabel.textAlignment = .center
        probabilityPlotXAxisTitleLabel.text = NSLocalizedString("Theoretical quantiles", comment: "")
        plotContainerView.addSubview(probabilityPlotXAxisTitleLabel)
        
        probabilityPlotView = CombinedChartView(frame: .zero)
        probabilityPlotView.translatesAutoresizingMaskIntoConstraints = false
        setupProbabilityChart()
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
//            plotContainerView.leadingAnchor.constraint(equalTo: tableView.trailingAnchor),
            plotContainerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            plotContainerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            
            
            distributionPlotTitleLabel.topAnchor.constraint(equalTo: plotContainerView.topAnchor, constant: interGraphDistance/2.0),
            distributionPlotTitleLabel.leadingAnchor.constraint(equalTo: plotContainerView.leadingAnchor),
            distributionPlotTitleLabel.trailingAnchor.constraint(equalTo: plotContainerView.trailingAnchor),
            distributionPlotTitleLabel.bottomAnchor.constraint(equalTo: distributionPlotView.topAnchor),
            distributionPlotTitleLabel.heightAnchor.constraint(equalToConstant: 30.0),
            
            distributionPlotView.topAnchor.constraint(equalTo: distributionPlotTitleLabel.bottomAnchor),
            distributionPlotView.leadingAnchor.constraint(equalTo: plotContainerView.leadingAnchor, constant: plotMargins),
            distributionPlotView.trailingAnchor.constraint(equalTo: plotContainerView.trailingAnchor, constant: -plotMargins),
            distributionPlotView.heightAnchor.constraint(equalToConstant: 300),
            
            distributionPlotXAxisTitleLabel.topAnchor.constraint(equalTo: distributionPlotView.bottomAnchor, constant: xAxisLabelMargin),
            distributionPlotXAxisTitleLabel.leadingAnchor.constraint(equalTo: distributionPlotView.leadingAnchor),
            distributionPlotXAxisTitleLabel.trailingAnchor.constraint(equalTo: distributionPlotView.trailingAnchor),
            
            
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
            
//            columnDescriptionView.topAnchor.constraint(equalTo: probabilityPlotXAxisTitleLabel.bottomAnchor, constant: interGraphDistance),
            columnDescriptionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            columnDescriptionView.centerXAnchor.constraint(equalTo: plotContainerView.centerXAnchor),
            columnDescriptionView.widthAnchor.constraint(equalToConstant: 300.0),
            
            
    
        ])
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        
        distributionPlotLeftAxisTitleLabel.frame = CGRect(x: distributionPlotView.frame.origin.x - 20.0,
                                                          y: distributionPlotView.frame.origin.y + 100.0,
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
        
        self.calculationQueue.calculate(data as! [Double], indexPath: indexPath) {
            (results, indexPath, error) in

            if let dataSet = results {
                
                let dataPoints = dataSet.points
                
                var entries = [BarChartDataEntry]()
                
                
                for point in dataPoints {
                    let entry = BarChartDataEntry(x: point.x.value, y: point.y.value)
                    
                    entries.append(entry)
                }
                let chartDataSet = BarChartDataSet(entries: entries)
                
                chartDataSet.drawValuesEnabled = false
                chartDataSet.axisDependency = .right
                
                let data = BarChartData(dataSets: [chartDataSet])
                
                
                data.barWidth = dataSet.width
                
                var freqEntries = [ChartDataEntry]()
                for freq in dataSet.frequencies {
                    let entry = ChartDataEntry(x: freq.x.value, y: freq.y.value)
                    freqEntries.append(entry)
                }
                
                var nfreqEntries = [ChartDataEntry]()
                for freq in dataSet.normalFrequencies {
                    let entry = ChartDataEntry(x: freq.x.value, y: freq.y.value)
                    nfreqEntries.append(entry)
                }
                
                let normalDataSet = LineChartDataSet(entries: freqEntries, label: NSLocalizedString("Frequency", comment: ""))
                normalDataSet.colors = [UIColor.red]
                normalDataSet.mode = .linear
                normalDataSet.drawCirclesEnabled = false
                normalDataSet.lineWidth = 2.0
                normalDataSet.axisDependency = .left
                
                let nnormalDataSet = LineChartDataSet(entries: nfreqEntries)
                nnormalDataSet.colors = [UIColor.brown]
                nnormalDataSet.mode = .linear
                nnormalDataSet.drawCirclesEnabled = false
                nnormalDataSet.lineWidth = 2.0
                nnormalDataSet.axisDependency = .left
                
                
                let combined = CombinedChartData()
                combined.lineData = LineChartData(dataSets: [normalDataSet, nnormalDataSet])
                combined.barData = data
//                combined.scatterData = ScatterChartData(dataSets: [chartDataSet])
                
                self.distributionPlotView.data = combined
                self.distributionPlotView.animate(xAxisDuration: 0.25, yAxisDuration: 0.25)
            }
            else {
                self.distributionPlotView.data = nil
                self.distributionPlotView.animate(xAxisDuration: 0.25, yAxisDuration: 0.25)
            }

        }
        
        self.calculationQueue.calculateProbabilityDistribution(data as! [Double], indexPath: indexPath) {
            (results, indexPath, error) in
            
            
            if let dataSet = results {
                
                let dataPoints = dataSet.points
                
                var entries = [ChartDataEntry]()
                for point in dataPoints {
                    let entry = ChartDataEntry(x: point.x.value, y: point.y.value)
                    
                    entries.append(entry)
                }
                
                var normalEntries = [ChartDataEntry]()
                for normal in dataSet.normal {
                    let entry = ChartDataEntry(x: normal.x.value, y: normal.y.value)
                    normalEntries.append(entry)
                }
                
                let normalDataSet = LineChartDataSet(entries: normalEntries)
                normalDataSet.colors = [UIColor.red]
                normalDataSet.mode = .linear
                normalDataSet.drawCirclesEnabled = false
                normalDataSet.lineWidth = 2.0
                
                let chartDataSet = ScatterChartDataSet(entries: entries)
                chartDataSet.drawValuesEnabled = false
                chartDataSet.setScatterShape(.circle)
                
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
