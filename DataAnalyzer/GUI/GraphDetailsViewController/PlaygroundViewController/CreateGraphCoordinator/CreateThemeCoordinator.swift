////
////  CreateThemeCoordinator.swift
////  DataAnalyzer
////
////  Created by Cihan Emre Kisakurek on 13.04.20.
////  Copyright © 2020 cekisakurek. All rights reserved.
////
//
//import UIKit
//
//class CreateThemeTableViewController: UITableViewController, ColorPickerFromTableViewDelegate {
//    
//    
//    class BarThemeDelegate: ColorPickerFromTableViewDelegate {
//        
//        weak var coordinator: CreateDatasetCoordinator?
//        weak var viewController: CreateDatasetTableViewController?
//        
//        func colorPicker(_ picker: ColorPickerViewController, didChange color: UIColor, forIndexPath: IndexPath) {
////            coordinator?.graph.barColor = color
//            viewController?.tableView.reloadData()
//        }
//    }
//    
//    
//    func colorPicker(_ picker: ColorPickerViewController, didChange color: UIColor, forIndexPath: IndexPath) {
//        self.coordinator?.changeColor(color, index: forIndexPath.row)
//    }
//    
//    weak var coordinator: CreateThemeCoordinator?
//    
//    class LineWidthDelegate: ObjectValueInputProtocol {
//        
////        weak var settings: Settings?
//        
//        func valueInputFieldChanged(toValue: Double?) {
////            if let settings = settings,
////                let value = toValue {
////                settings.dgNormalLineWidth = value
////            }
//        }
//    }
//    
//    @objc func createGraph() {
//        self.coordinator?.saveGraph()
//    }
//    
//    override func loadView() {
//        super.loadView()
//        
//        self.tableView.estimatedRowHeight = 100.0;
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//        self.tableView.register(StaticTextTableViewCell.self, forCellReuseIdentifier: "StaticValueCell")
//        
//        self.tableView.register(ColorSelectionTableViewCell.self, forCellReuseIdentifier: "ColorCell")
//        
//        let createItem = UIBarButtonItem(title: NSLocalizedString("Create", comment: ""), style: .plain, target: self, action: #selector(createGraph))
//        self.navigationItem.rightBarButtonItem = createItem
//        
//        
//    }
//    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        
//        return 1
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return self.coordinator?.themeItems().count ?? 0
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        if indexPath.section == 0 {
//            
//            
//        }
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "StaticValueCell", for: indexPath) as! StaticTextTableViewCell
//        let item = self.coordinator?.themeItems()[indexPath.row]
//        if let color = self.coordinator?.colorForIndex(indexPath.row) {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ColorCell", for: indexPath) as! ColorSelectionTableViewCell
//            cell.accessoryType = .disclosureIndicator
//            cell.setValueName(item, color: color)
//            return cell
//        }
//        return cell
//        
//    }
//    
//    // MARK: - UITableViewDelegate
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//                
//        let pickerViewController = ColorPickerViewController()
//        pickerViewController.fromIndexPath = indexPath
//        pickerViewController.tableColorDelegate = self
//        self.navigationController?.pushViewController(pickerViewController, animated: true)
//    }
//}
//
//
//class CreateThemeCoordinator: Coordinator {
//
//    required override init() {
//        super.init()
//        
//        let viewController = CreateThemeTableViewController(style: .plain)
//        viewController.coordinator = self
//        viewController.title = NSLocalizedString("Create Theme", comment: "")
//        self.rootViewController = viewController
//        
//    }
//    
//    func start() {
//        
//        if let parentCoordinator = parentCoordinator {
//            parentCoordinator.rootViewController.navigationController!.pushViewController(self.rootViewController, animated: true)
//        }
//    }
//    
//    func themeItems() -> [String] {
//        
//        var items = [NSLocalizedString("Background Color", comment: "")]
//        switch self.graph.type {
//            case .Bar:
//                items.append(NSLocalizedString("Bar Color", comment: ""))
//            case .Line:
//                items.append(NSLocalizedString("Line Color", comment: ""))
//                items.append(NSLocalizedString("Line Width", comment: ""))
//            case .Scatter:
//                items.append(NSLocalizedString("Point Color", comment: ""))
//                items.append(NSLocalizedString("Point Size", comment: ""))
//            default:
//                break
//        }
//        return items
//    }
//    
//    func changeColor(_ color: UIColor, index: Int) {
//        switch index {
//            case 0:
//                graph.backgroundColor = color
//            case 1:
//                break
//                
//            default:
//                break;
//        }
//    }
//    
//    func colorForIndex(_ index: Int) -> UIColor?{
//        switch index {
//            case 0:
//                return graph.backgroundColor
//            case 1:
//                break
//            default:
//                break;
//        }
//        return nil
//    }
//    
//    func saveGraph() {
//        
//        do {
//            
//            if let context = CoreDataController.shared.managedObjectContext {
//                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Dataset")
//                fetchRequest.predicate = NSPredicate(format: "uuid == %@", graph.uuid)
//                let datasets = try context.fetch(fetchRequest) as! [Dataset]
//                
//                if let selectedSet = datasets.first {
//                    
//                    let graphObject = NSEntityDescription.insertNewObject(forEntityName: "Graph", into: CoreDataController.shared.managedObjectContext) as! Graph
//                    
//                    graphObject.backgroundColor = graph.backgroundColor
//                    graphObject.createdDate = Date()
//                    graphObject.name = graph.name
//                    graphObject.titleColor = graph.titleColor
//                    graphObject.titleFontName = graph.titleFontName
//                    graphObject.titleFontSize = graph.titleFontSize
//                    graphObject.type = self.graph.type.rawValue
//                    
//                    graphObject.xAxisTextColor = graph.yAxisTextColor
//                    graphObject.xAxisTextFontName = graph.yAxisTextFontName
//                    graphObject.xAxisTextFontSize = graph.yAxisTextFontSize
//                    
//                    
//                    graphObject.yAxisTextColor = graph.yAxisTextColor
//                    graphObject.yAxisTextFontName = graph.yAxisTextFontName
//                    graphObject.yAxisTextFontSize = graph.yAxisTextFontSize
//                    
//                    graphObject.workset = selectedSet
//                    
//                    var i = 0
//                    for set in self.graph.datasets {
//                        let graphData = NSEntityDescription.insertNewObject(forEntityName: "GraphData", into: CoreDataController.shared.managedObjectContext) as! GraphData
//                        
//                        if i == 0 {
//                            graphObject.xAxisName = set.xAxisName
//                            graphObject.yAxisName = set.yAxisName
//                        }
//                        
//                        graphData.xAxis = set.xAxisName
//                        graphData.yAxis = set.yAxisName
//                        
//                        switch graph.type {
//                            case .Bar:
//                                graphData.barColor = set.barColor
//                            case .Line:
//                                graphData.lineWidth = set.lineWidth
//                                graphData.lineColor = set.lineColor
//                            case .Scatter:
//                                graphData.circleSize = set.circleSize
//                                graphData.circleColor = set.circleColor
//                            case .None:
//                                break;
//                        }
//                        graphObject.addToData(graphData)
//                        
//                        i += 1
//                    }
//                    try CoreDataController.shared.managedObjectContext.save()
//                    
//                }
//            }
//            dismiss()
//            
//        }
//        catch {
//            print(error)
//            dismiss()
//        }
//    }
//    
//    func dismiss() {
//        
//        self.rootViewController.navigationController?.dismiss(animated: true, completion: {
//            
//        })
//    }
//}
