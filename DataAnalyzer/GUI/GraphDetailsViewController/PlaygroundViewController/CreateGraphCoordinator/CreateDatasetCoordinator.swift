//
//  CreateDatasetTableViewController.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 11.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit
import CoreData

class CreateDatasetTableViewController: UITableViewController   {
    
    class BarGraphDelegate: ColorPickerFromTableViewDelegate {
        
        weak var coordinator: CreateDatasetCoordinator?
        weak var viewController: CreateDatasetTableViewController?
        
        func colorPicker(_ picker: ColorPickerViewController, didChange color: UIColor, forIndexPath: IndexPath) {
            coordinator?.currentDataset().barColor = color
            viewController?.tableView.reloadData()
        }
    }
    
    class LineGraphDelegate: ColorPickerFromTableViewDelegate, ObjectValueInputProtocol {
        
        func valueInputFieldChanged(toValue: Double?) {
            coordinator?.currentDataset().lineWidth = toValue!
        }
        
        
        weak var coordinator: CreateDatasetCoordinator?
        weak var viewController: CreateDatasetTableViewController?
        
        func colorPicker(_ picker: ColorPickerViewController, didChange color: UIColor, forIndexPath: IndexPath) {
            coordinator?.currentDataset().lineColor = color
            viewController?.tableView.reloadData()
        }
    }
    
    class ScatterGraphDelegate: ColorPickerFromTableViewDelegate, ObjectValueInputProtocol {
        
        func valueInputFieldChanged(toValue: Double?) {
            coordinator?.currentDataset().circleSize = toValue!
        }
        
        
        weak var coordinator: CreateDatasetCoordinator?
        weak var viewController: CreateDatasetTableViewController?
        
        func colorPicker(_ picker: ColorPickerViewController, didChange color: UIColor, forIndexPath: IndexPath) {
            coordinator?.currentDataset().circleColor = color
            viewController?.tableView.reloadData()
        }
    }
    
    
    class XAxisDelegate: ObjectNamingProtocol, PlaygroundGraphValueSelectionDelegate, ColorPickerFromTableViewDelegate {
        
        weak var coordinator: CreateDatasetCoordinator?
        weak var viewController: CreateDatasetTableViewController?
        
        func colorPicker(_ picker: ColorPickerViewController, didChange color: UIColor, forIndexPath: IndexPath) {
            coordinator?.graph.xAxisTextColor = color
            viewController?.tableView.reloadData()
        }
        
        func objectNameFieldChanged(toString: String?) {
            coordinator?.graph.xAxisDisplayName = toString
        }
        
        func itemSelected(_ selected: Selectable) {
            viewController?.selectedXAxis = selected
            viewController?.tableView.reloadData()
        }
    }
    
    class YAxisDelegate: ObjectNamingProtocol, PlaygroundGraphValueSelectionDelegate, ColorPickerFromTableViewDelegate {
        
        weak var coordinator: CreateDatasetCoordinator?
        weak var viewController: CreateDatasetTableViewController?
        
        func colorPicker(_ picker: ColorPickerViewController, didChange color: UIColor, forIndexPath: IndexPath) {
            coordinator?.graph.yAxisTextColor = color
            viewController?.tableView.reloadData()
        }
        
        func objectNameFieldChanged(toString: String?) {
            coordinator?.graph.yAxisDisplayName = toString
        }
        
        func itemSelected(_ selected: Selectable) {
            viewController?.selectedYAxis = selected
            viewController?.tableView.reloadData()
        }
    }
    
    private var xAxisDelegate = XAxisDelegate()
    private var yAxisDelegate = YAxisDelegate()
    
    private var barGraphDelegate = BarGraphDelegate()
    private var lineGraphDelegate = LineGraphDelegate()
    private var scatterGraphDelegate = ScatterGraphDelegate()
    
    weak var coordinator: CreateDatasetCoordinator?
    
    var selectedXAxis: Selectable? {
        didSet {
           toggleNextButton()
        }
    }
    var selectedYAxis: Selectable? {
        didSet {
           toggleNextButton()
        }
    }
    
    func toggleNextButton() {
        if selectedXAxis != nil && selectedYAxis != nil {
            
            let nextItem = UIBarButtonItem(title: NSLocalizedString("Create", comment: ""), style: .plain, target: self, action: #selector(advance))
            self.navigationItem.rightBarButtonItem = nextItem
        }
        else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func loadView() {
        super.loadView()
        
        xAxisDelegate.coordinator = coordinator
        xAxisDelegate.viewController = self
        
        yAxisDelegate.coordinator = coordinator
        yAxisDelegate.viewController = self
        
        barGraphDelegate.coordinator = coordinator
        barGraphDelegate.viewController = self
        
        lineGraphDelegate.coordinator = coordinator
        lineGraphDelegate.viewController = self
        
        scatterGraphDelegate.coordinator = coordinator
        scatterGraphDelegate.viewController = self
        
        self.tableView.estimatedRowHeight = 100.0;
        self.tableView.register(NameInputTableViewCell.self, forCellReuseIdentifier: "NameCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.register(StaticTextTableViewCell.self, forCellReuseIdentifier: "StaticValueCell")
        self.tableView.register(ColorSelectionTableViewCell.self, forCellReuseIdentifier: "ColorCell")
        self.tableView.register(DoubleValueInputTableViewCell.self, forCellReuseIdentifier: "DoubleValueCell")
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 3
            case 1:
                return 3
            case 2:
                switch self.coordinator?.graph.type {
                    case .Bar:
                        return 1
                    case .Line:
                        return 2
                    case .Scatter:
                        return 2
                    default:
                        return 0
                }
            default:
                return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0:
                return NSLocalizedString("X Axis", comment: "")
            case 1:
                return NSLocalizedString("Y Axis", comment: "")
            case 2:
                return NSLocalizedString("Data Presentation", comment: "")
            default:
                return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "StaticValueCell", for: indexPath) as! StaticTextTableViewCell
                let nameString = NSLocalizedString("Select X-Axis Column", comment: "") + " :"
                let valueString = selectedXAxis?.value as? String
                cell.setValueName(nameString, value: valueString)
                return cell
            }
            else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as! NameInputTableViewCell
                cell.setPlaceholder("Display Name")
                cell.nameFieldChangeDelegate = xAxisDelegate
                return cell
            }
            else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ColorCell", for: indexPath) as! ColorSelectionTableViewCell
                cell.accessoryType = .disclosureIndicator
                let name = NSLocalizedString("Text Color", comment: "") + " :"
                let color = self.coordinator?.graph.xAxisTextColor
                cell.setValueName(name, color: color)
                return cell
            }
            
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "StaticValueCell", for: indexPath) as! StaticTextTableViewCell
                let nameString = NSLocalizedString("Select Y-Axis Column", comment: "") + " :"
                let valueString = selectedYAxis?.value as? String
                cell.setValueName(nameString, value: valueString)
                return cell
            }
            else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as! NameInputTableViewCell
                cell.setPlaceholder("Display Name")
                cell.nameFieldChangeDelegate = yAxisDelegate
                return cell
            }
            else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ColorCell", for: indexPath) as! ColorSelectionTableViewCell
                cell.accessoryType = .disclosureIndicator
                let name = NSLocalizedString("Text Color", comment: "") + " :"
                let color = self.coordinator?.graph.yAxisTextColor
                cell.setValueName(name, color: color)
                return cell
            }
        }
        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                switch self.coordinator?.graph.type {
                case .Bar:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ColorCell", for: indexPath) as! ColorSelectionTableViewCell
                    cell.accessoryType = .disclosureIndicator
                    let name = NSLocalizedString("Bar Color", comment: "") + " :"
                    let color = self.coordinator?.currentDataset().barColor
                    cell.setValueName(name, color: color)
                    return cell
                case .Line:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ColorCell", for: indexPath) as! ColorSelectionTableViewCell
                    cell.accessoryType = .disclosureIndicator
                    let name = NSLocalizedString("Line Color", comment: "") + " :"
                    let color = self.coordinator?.currentDataset().lineColor
                    cell.setValueName(name, color: color)
                    return cell
                case .Scatter:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ColorCell", for: indexPath) as! ColorSelectionTableViewCell
                    cell.accessoryType = .disclosureIndicator
                    let name = NSLocalizedString("Circle Color", comment: "") + " :"
                    let color = self.coordinator?.currentDataset().circleColor
                    cell.setValueName(name, color: color)
                    return cell
                default:
                    break
                }
            }
            else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DoubleValueCell", for: indexPath) as! DoubleValueInputTableViewCell
                cell.accessoryType = .none
                switch self.coordinator?.graph.type {
                    case .Line:
                        cell.valueFieldChangeDelegate = lineGraphDelegate
                        let item = NSLocalizedString("Line Width", comment: "")
                        let value = self.coordinator?.currentDataset().lineWidth
                        cell.setValueName(item, value: value)
                    case .Scatter:
                        cell.valueFieldChangeDelegate = scatterGraphDelegate
                        let item = NSLocalizedString("Circle Size", comment: "")
                        let value = self.coordinator?.currentDataset().circleSize
                        cell.setValueName(item, value: value)
                    default:
                        break
                }
                
                return cell
            }
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
        
    }

    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let selectionViewController = PlaygroundGraphValueSelectionTableView(style: .plain)
                selectionViewController.items = self.coordinator?.selectableItems()
                selectionViewController.selectionDelegate = xAxisDelegate
                self.navigationController?.pushViewController(selectionViewController, animated: true)
            }
            else if indexPath.row == 2 {
                let pickerViewController = ColorPickerViewController()
                pickerViewController.fromIndexPath = indexPath
                pickerViewController.tableColorDelegate = xAxisDelegate
                self.navigationController?.pushViewController(pickerViewController, animated: true)
            }
            
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let selectionViewController = PlaygroundGraphValueSelectionTableView(style: .plain)
                selectionViewController.items = self.coordinator?.selectableItems()
                selectionViewController.selectionDelegate = yAxisDelegate
                self.navigationController?.pushViewController(selectionViewController, animated: true)
            }
            else if indexPath.row == 2 {
                let pickerViewController = ColorPickerViewController()
                pickerViewController.fromIndexPath = indexPath
                pickerViewController.tableColorDelegate = yAxisDelegate
                self.navigationController?.pushViewController(pickerViewController, animated: true)
            }
        }
        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let pickerViewController = ColorPickerViewController()
                pickerViewController.fromIndexPath = indexPath
                switch self.coordinator?.graph.type {
                    case .Bar:
                        pickerViewController.tableColorDelegate = barGraphDelegate
                        break
                    case .Line:
                        pickerViewController.tableColorDelegate = lineGraphDelegate
                        break
                    case .Scatter:
                        pickerViewController.tableColorDelegate = scatterGraphDelegate
                        break
                    default:
                        break
                }
                self.navigationController?.pushViewController(pickerViewController, animated: true)
            }
        }
    }

    @objc func advance() {
        let coordinator = self.coordinator!
        coordinator.setAxisNames(x: (self.selectedXAxis!.value as! String), y: (self.selectedYAxis!.value as! String))
    }
}


class CreateDatasetCoordinator: Coordinator {
    
    required init(type: PlaygroundGraphType) {
        super.init()
        
        let viewController = CreateDatasetTableViewController(style: .plain)
        viewController.coordinator = self
        viewController.title = NSLocalizedString("Create Dataset", comment: "")
        self.rootViewController = viewController
        
    }
    
    func selectableItems() -> [Selectable] {
        
        var items = [Selectable]()
        for name in self.graph.availableHeaders {
            let s = Selectable(key: name, value: name)
            items.append(s)
        }
        return items
    }
    
    func start() {
        
        if let parentCoordinator = parentCoordinator {
            parentCoordinator.rootViewController.navigationController!.pushViewController(self.rootViewController, animated: true)
        }
    }
    
    func currentDataset() -> GraphDataSet {
        
        if let currentSet = self.graph.datasets.first {
            return currentSet
        }
        else {
            let set = GraphDataSet()
            self.graph.datasets.append(set)
            return set
        }
    }
    
    func setAxisNames(x: String, y: String) {
        
        if let currentSet = self.graph.datasets.first {
            currentSet.xAxisName = x
            currentSet.yAxisName = y
        }
        else {
            let set = GraphDataSet()
            set.xAxisName = x
            set.yAxisName = y
            self.graph.datasets.append(set)
        }
        self.saveGraph()
    }
    
    func saveGraph() {
        
        do {
            
            if let context = CoreDataController.shared.managedObjectContext {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Dataset")
                fetchRequest.predicate = NSPredicate(format: "uuid == %@", graph.uuid)
                let datasets = try context.fetch(fetchRequest) as! [Dataset]
                
                if let selectedSet = datasets.first {
                    
                    let graphObject = NSEntityDescription.insertNewObject(forEntityName: "Graph", into: CoreDataController.shared.managedObjectContext) as! Graph
                    
                    graphObject.backgroundColor = graph.backgroundColor
                    let currentDate = Date()
                    graphObject.createdDate = currentDate
                    if let chosenName = graph.name {
                        graphObject.name = chosenName
                    }
                    else {
                        let formatter = DateFormatter()
                        formatter.dateStyle = .medium
                        formatter.timeStyle = .medium
                        graphObject.name = formatter.string(from: currentDate)
                    }
                    
                    graphObject.titleColor = graph.titleColor
                    graphObject.titleFontName = graph.titleFontName
                    graphObject.titleFontSize = graph.titleFontSize
                    graphObject.type = self.graph.type.rawValue
                    
                    graphObject.xAxisTextColor = graph.xAxisTextColor
                    graphObject.xAxisTextFontName = graph.xAxisTextFontName
                    graphObject.xAxisTextFontSize = graph.xAxisTextFontSize
                    
                    
                    graphObject.yAxisTextColor = graph.yAxisTextColor
                    graphObject.yAxisTextFontName = graph.yAxisTextFontName
                    graphObject.yAxisTextFontSize = graph.yAxisTextFontSize
                    
                    graphObject.workset = selectedSet
                    
                    var i = 0
                    for set in self.graph.datasets {
                        let graphData = NSEntityDescription.insertNewObject(forEntityName: "GraphData", into: CoreDataController.shared.managedObjectContext) as! GraphData
                        
                        if i == 0 {
                            graphObject.xAxisName = set.xAxisName
                            graphObject.yAxisName = set.yAxisName
                        }
                        
                        graphData.xAxis = set.xAxisName
                        graphData.yAxis = set.yAxisName
                        
                        switch graph.type {
                            case .Bar:
                                graphData.barColor = set.barColor
                            case .Line:
                                graphData.lineWidth = set.lineWidth
                                graphData.lineColor = set.lineColor
                            case .Scatter:
                                graphData.circleSize = set.circleSize
                                graphData.circleColor = set.circleColor
                            case .None:
                                break;
                        }
                        graphObject.addToData(graphData)
                        
                        i += 1
                    }
                    try CoreDataController.shared.managedObjectContext.save()
                    
                }
            }
            dismiss()
            
        }
        catch {
            print(error)
            dismiss()
        }
    }
    
    func dismiss() {
        
        self.rootViewController.navigationController?.dismiss(animated: true, completion: {
            
        })
    }
}
