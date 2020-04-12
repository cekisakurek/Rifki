//
//  PlaygroundViewController.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 11.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit

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
    
    var distributionPlotLeftAxisTitleLabel: UILabel!
    var distributionPlotXAxisTitleLabel: UILabel!
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.white
        
        let axisLabelFonts = UIFont.systemFont(ofSize: 13.0)
        let plotTitleFont = UIFont.boldSystemFont(ofSize: 20.0)
        
        let distributionPlotTitleLabel = UILabel(frame: .zero)
        distributionPlotTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        distributionPlotTitleLabel.font = plotTitleFont
        distributionPlotTitleLabel.textColor = UIColor.black
        distributionPlotTitleLabel.textAlignment = .center
        distributionPlotTitleLabel.text = graph?.name
        self.view.addSubview(distributionPlotTitleLabel)
        
        distributionPlotLeftAxisTitleLabel = UILabel(frame: CGRect(x: 0, y: 0.0, width: self.view.bounds.size.height, height: 50.0))
//        distributionPlotLeftAxisTitleLabel.backgroundColor = UIColor.red
        distributionPlotLeftAxisTitleLabel.font = axisLabelFonts
        distributionPlotLeftAxisTitleLabel.textColor = UIColor.black
        distributionPlotLeftAxisTitleLabel.textAlignment = .center
        distributionPlotLeftAxisTitleLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        self.view.addSubview(distributionPlotLeftAxisTitleLabel)
        
        
        
        distributionPlotXAxisTitleLabel = UILabel(frame: .zero)
        distributionPlotXAxisTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        distributionPlotXAxisTitleLabel.font = axisLabelFonts
        distributionPlotXAxisTitleLabel.textColor = UIColor.black
        distributionPlotXAxisTitleLabel.textAlignment = .center
        self.view.addSubview(distributionPlotXAxisTitleLabel)
        
        graphView = CombinedChartView(frame: .zero)
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.delegate = self
        graphView.legend.enabled = false
        graphView.backgroundColor = UIColor.white
//        graphView.isHidden = true
        let xAxis = graphView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = UIColor.black
        
        graphView.autoScaleMinMaxEnabled = false
        
        graphView.xAxis.gridColor = .clear
        graphView.leftAxis.gridColor = .clear
        graphView.rightAxis.gridColor = .clear
        
        graphView.leftAxis.labelTextColor = UIColor.black
        graphView.rightAxis.labelTextColor = UIColor.black
        graphView.xAxis.labelTextColor = UIColor.black
        graphView.isUserInteractionEnabled = false
        
        graphView.layer.borderColor = UIColor.lightGray.cgColor
        graphView.layer.borderWidth = 1.0
        
        graphView.noDataTextColor = UIColor.black
        graphView.noDataText = NSLocalizedString("No chart data available.", comment: "")
        self.view.addSubview(graphView)
        
        let leftMargin = CGFloat(50.0)
        let rightMargin = CGFloat(50.0)
        let titleMargin = CGFloat(50.0)
        let titleTopMargin = CGFloat(40.0)
        let plotBottomMargin = CGFloat(40.0)
        
        NSLayoutConstraint.activate([
            distributionPlotTitleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: titleTopMargin),
            distributionPlotTitleLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: leftMargin),
            distributionPlotTitleLabel.bottomAnchor.constraint(equalTo: graphView.topAnchor, constant: -titleMargin),
            distributionPlotTitleLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -rightMargin),
            
            graphView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: leftMargin),
            graphView.bottomAnchor.constraint(equalTo: distributionPlotXAxisTitleLabel.topAnchor),
            graphView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -rightMargin),
            
            distributionPlotXAxisTitleLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: leftMargin),
            distributionPlotXAxisTitleLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -plotBottomMargin),
            distributionPlotXAxisTitleLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -rightMargin),
            distributionPlotXAxisTitleLabel.heightAnchor.constraint(equalToConstant: 50.0)
        ])
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        distributionPlotLeftAxisTitleLabel.frame = CGRect(x: 0.0,
                                                          y: graphView.frame.origin.y,
                                                          width: distributionPlotLeftAxisTitleLabel.frame.size.width, height: graphView.frame.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for graphData in graph!.data!  {
            
            
            
            if let d = graphData as? GraphData {
                let xAxis = d.xAxis!
                let yAxis = d.yAxis!
                
                distributionPlotXAxisTitleLabel.text = xAxis
                distributionPlotLeftAxisTitleLabel.text = yAxis
                
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
                    
                    let chartDataSet = LineChartDataSet(entries: entries)
                    chartDataSet.colors = [UIColor.red]
                    chartDataSet.mode = .linear
                    chartDataSet.drawCirclesEnabled = false
                    chartDataSet.lineWidth = 2.0
                    
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
                    
                    
                    let chartDataSet = BarChartDataSet(entries: entries)
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
                    
                    let chartDataSet = ScatterChartDataSet(entries: entries)
                    chartDataSet.drawValuesEnabled = false
                    chartDataSet.setScatterShape(.circle)
                    
                    let combinedChart = CombinedChartData()
                    combinedChart.scatterData = ScatterChartData(dataSet: chartDataSet)
                    self.graphView.data = combinedChart
                }
                
            }
        }
    }
}
