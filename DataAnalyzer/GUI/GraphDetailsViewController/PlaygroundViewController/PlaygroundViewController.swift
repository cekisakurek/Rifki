//
//  PlaygroundViewController.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 11.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit
import CoreData

let leftAndRightPaddings: CGFloat = 10.0

class PlaygroundViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController<Graph>!
    
    var createGraphCoordinator: CreateGraphCoordinator?
    var dataset: GraphRawData?
    
    var worksetUUID: String?
    
    class func defaultPlaygroundViewController() -> PlaygroundViewController {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = leftAndRightPaddings/2.0
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        flowLayout.itemSize = CGSize(width: 300.0, height: 200.0)
        
        let viewController = PlaygroundViewController(collectionViewLayout: flowLayout)
        return viewController
    
    }
    
    
    
    override func loadView() {
        super.loadView()
        
        self.collectionView.backgroundColor = UIColor.white
        
        self.collectionView.register(AddGraphCollectionViewCell.self, forCellWithReuseIdentifier: "AddGraphCell")
        self.collectionView.register(GraphThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: "GraphThumbnailCell")
        
        loadSavedData()
    }
    
    func loadSavedData() {
        
        if self.fetchedResultsController == nil,
            let dataset = dataset {
            
            do {
                if let context = CoreDataController.shared.managedObjectContext {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Dataset")
                    fetchRequest.predicate = NSPredicate(format: "uuid == %@", dataset.uuid)
                    let datasets = try context.fetch(fetchRequest) as! [Dataset]
                    
                    if let selectedSet = datasets.first {
                        
                        let request: NSFetchRequest<Graph> = Graph.fetchRequest()
                        let sort = NSSortDescriptor(key: "createdDate", ascending: false)
                        let predicate = NSPredicate(format: "workset == %@", selectedSet)
                        request.sortDescriptors = [sort]
                        request.fetchBatchSize = 20
                        request.predicate = predicate
                        
                        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                                   managedObjectContext: CoreDataController.shared.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
                        self.fetchedResultsController.delegate = self
                        try self.fetchedResultsController.performFetch()
                    }
                }
            }
            catch {
                print("Fetch failed")
            }
            
            
            
            
    
        }
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if let fetchedResultsController = fetchedResultsController,
            let sectionInfo = fetchedResultsController.sections{
            
            return sectionInfo.count
        }
        else {
            return 1
        }
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let fetchedResultsController = fetchedResultsController,
            let sectionInfo = fetchedResultsController.sections?[section]{
            
            return sectionInfo.numberOfObjects + 1
        }
        else {
            return 1
        }
    }

    // make a cell for each cell index path
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.section == 0 && indexPath.row == 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "AddGraphCell", for: indexPath as IndexPath) as! AddGraphCollectionViewCell
        }
        
        
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GraphThumbnailCell", for: indexPath as IndexPath) as! GraphThumbnailCollectionViewCell

        var translatedIndexPath = indexPath
        translatedIndexPath.row -= 1
        
        let graph = fetchedResultsController.object(at: translatedIndexPath)
        cell.setName(graph.name)
        
//        cell.backgroundColor = UIColor.cyan // make cell more visible in our example project

        return cell
    }

    // MARK: - UICollectionViewDelegate protocol

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        if indexPath.section == 0 && indexPath.row == 0 {
            
            createGraphCoordinator = CreateGraphCoordinator(with: self, availableHeaders: dataset!.headers!, uuid: dataset!.uuid)
            createGraphCoordinator?.start()
            
//            let fontConfig = UIFontPickerViewController.Configuration()
//            fontConfig.includeFaces = true
//            let fontPicker = UIFontPickerViewController(configuration: fontConfig)
////            fontPicker.delegate = self
//            self.present(fontPicker, animated: true, completion: nil)
                
        }
        else {
            var translatedIndexPath = indexPath
            translatedIndexPath.row -= 1
            let graph = fetchedResultsController.object(at: translatedIndexPath)
            
            let viewController = PlaygroundGraphViewController()
            viewController.graph = graph
            viewController.dataset = dataset
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}


class AddGraphCollectionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        
        let imageView = UIImageView(image: UIImage(named: "graphPlaceholder"))
        imageView.center = self.contentView.center
        let label = UILabel(frame: CGRect(x: 0.0, y: imageView.bounds.size.height + imageView.frame.origin.y, width: self.contentView.bounds.size.width, height: 20.0))
        label.text = NSLocalizedString("Add Graph", comment: "")
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textAlignment = .center
        
        
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(label)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class GraphThumbnailCollectionViewCell: UICollectionViewCell {

    var label: UILabel!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        
        let imageView = UIImageView(image: UIImage(named: "graphPlaceholder"))
        imageView.center = self.contentView.center
        
        label = UILabel(frame: CGRect(x: 0.0, y: imageView.bounds.size.height + imageView.frame.origin.y, width: self.contentView.bounds.size.width, height: 20.0))
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textAlignment = .center
        
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(label)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setName(_ name: String?) {
        label.text = name
    }
    
}




class PlaygroundGraphViewController: UIViewController, ChartViewDelegate {
    
    var dataset: GraphRawData?
    var graph: Graph?
    
    private var graphView: CombinedChartView!
    
    private var plotTitleLabel: UILabel!
    
    var leftAxisTitleLabel: UILabel!
    var bottomAxisTitleLabel: UILabel!
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.white
        
        
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
        
        if name == ".SFNS-Regular" {
            return UIFont.systemFont(ofSize: size)
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
            plotTitleLabel.font = UIFont(name: graph.titleFontName!, size: CGFloat(graph.titleFontSize))
            plotTitleLabel.textColor = graph.titleColor as? UIColor
            
            leftAxisTitleLabel.text = graph.yAxisName
            leftAxisTitleLabel.font = self.fontWithName(graph.yAxisTextFontName!, size: CGFloat(graph.yAxisTextFontSize))
            leftAxisTitleLabel.textColor = graph.yAxisTextColor as? UIColor
            
            bottomAxisTitleLabel.text = graph.xAxisName
            bottomAxisTitleLabel.font = self.fontWithName(graph.xAxisTextFontName!, size: CGFloat(graph.xAxisTextFontSize))
            bottomAxisTitleLabel.textColor = graph.xAxisTextColor as? UIColor
            
            graphView.leftAxis.labelTextColor = graph.yAxisTextColor as? UIColor ?? UIColor.black
            graphView.rightAxis.labelTextColor = graph.yAxisTextColor as? UIColor ?? UIColor.black
            graphView.xAxis.labelTextColor = graph.xAxisTextColor as? UIColor ?? UIColor.black
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
