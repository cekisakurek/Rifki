//
//  CreateGraphCoordinator.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 11.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit


enum PlaygroundGraphType: String {
    case None
    case Line
    case Bar
    case Scatter
}

class GraphDataSet {
    var xAxisName: String!
    var yAxisName: String!
    
    var lineWidth: Double = 10.0
    var lineColor: UIColor = UIColor.cyan
    
    var circleSize: Double = 5.0
    var circleColor: UIColor = UIColor.cyan
    
    var barColor: UIColor = UIColor.cyan
}

let systemBoldFontName = "System-Bold"
let systemFontName = "System"

class PlaygroundGraph {
    var name: String?
    var type: PlaygroundGraphType = .None
    var datasets: [GraphDataSet] = [GraphDataSet]()
    var uuid: String!
    var availableHeaders: [String]!
    
    var titleFontSize: Double = 40.0
    
    var titleFontName: String = systemBoldFontName
    var titleColor: UIColor = UIColor.black
    
    var backgroundColor: UIColor = UIColor.white
    
    var xAxisDisplayName: String?
    var yAxisTextFontSize: Double = 30.0
    var yAxisTextFontName: String = systemFontName
    var yAxisTextColor: UIColor = UIColor.black
    
    var yAxisDisplayName: String?
    var xAxisTextFontSize: Double = 30.0
    var xAxisTextFontName: String = systemFontName
    var xAxisTextColor: UIColor = UIColor.black
}

struct Selectable {
    
    var key: String
    var value: Any
}

class Coordinator {
    weak var parentCoordinator: Coordinator?
    var subCoordiantors = [Coordinator]()
    var rootViewController: UIViewController!
    var graph: PlaygroundGraph!
}

class CreateGraphCoordinator: Coordinator {
    
    weak var presentViewController: UIViewController!
    
    init(with presentViewController: UIViewController, availableHeaders: [String], uuid: String) {
        super.init()
        let graph = PlaygroundGraph()
        graph.availableHeaders = availableHeaders
        graph.uuid = uuid
        self.graph = graph
        self.presentViewController = presentViewController
    }
    
    func start() {
        
        let createGraphViewController = CreateGraphNameTypeViewController(style: .plain)
        createGraphViewController.coordinator = self
        createGraphViewController.title = NSLocalizedString("Graph Creation", comment: "")
        let navigationController = UINavigationController(rootViewController: createGraphViewController)
        self.rootViewController = navigationController
        self.presentViewController.present(navigationController, animated: true)
    }
    
    func cancel() {
        self.rootViewController.dismiss(animated: true)
    }
    
    func save() {
        self.rootViewController.dismiss(animated: true)
    }
    
    func graphTypes() -> [Selectable] {
        
        let bar = Selectable(key: NSLocalizedString("Bar Graph", comment: ""), value: PlaygroundGraphType.Bar)
        let line = Selectable(key: NSLocalizedString("Line Graph", comment: ""), value: PlaygroundGraphType.Line)
        let scatter = Selectable(key: NSLocalizedString("Scatter Graph", comment: ""), value: PlaygroundGraphType.Scatter)
        
        return [bar, line, scatter]
    }
    
    func selectGraphType() {
        let subCoordinator = CreateGraphTypeCoordinator()
        subCoordinator.graph = graph
        self.subCoordiantors.append(subCoordinator)
        subCoordinator.parentCoordinator = self
        subCoordinator.start()
        
    }
}

class CreateGraphNameTypeViewController: UITableViewController,
                                         ObjectNamingProtocol,
                                         ObjectValueInputProtocol,
                                         ColorPickerFromTableViewDelegate,
                                         FontSelectionDelegate {
    
    var items: [Selectable]!
    weak var coordinator: CreateGraphCoordinator?
    
    // MARK: - FontSelectionDelegate
    
    func fontSelectionController(_ controller: FontSelectionTableViewController, didSelect font: UIFont) {
        self.coordinator?.graph.titleFontName = font.fontName
        tableView.reloadData()
    }
    
    // MARK: - ObjectValueInputProtocol
    
    func valueInputFieldChanged(toValue: Double?) {
        if let value = toValue {
            self.coordinator?.graph.titleFontSize = value
        }
    }
    
    // MARK: - ColorPickerFromTableViewDelegate
    
    func colorPicker(_ picker: ColorPickerViewController, didChange color: UIColor, forIndexPath: IndexPath) {
        if forIndexPath.row == 1 {
            self.coordinator?.graph.titleColor = color
        }
        else if forIndexPath.row == 2 {
            self.coordinator?.graph.backgroundColor = color
        }
        tableView.reloadData()
    }
    
    // MARK: - ObjectNamingProtocol
    
    func objectNameFieldChanged(toString: String?) {
        self.coordinator?.graph.name = toString
    }
    
    override func loadView() {
        super.loadView()
        
        let cancelItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(cancelled))
        self.navigationItem.leftBarButtonItem = cancelItem
    
        self.tableView.estimatedRowHeight = 100.0;
        self.tableView.register(NameInputTableViewCell.self, forCellReuseIdentifier: "NameCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.register(StaticTextTableViewCell.self, forCellReuseIdentifier: "StaticValueCell")
        self.tableView.register(ColorSelectionTableViewCell.self, forCellReuseIdentifier: ColorSelectionTableViewCell.identifier)
        self.tableView.register(DoubleValueInputTableViewCell.self, forCellReuseIdentifier: DoubleValueInputTableViewCell.identifier)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
        
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as! NameInputTableViewCell
            cell.setPlaceholder("New Graph")
            cell.nameFieldChangeDelegate = self
            return cell
        }
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ColorCell", for: indexPath) as! ColorSelectionTableViewCell
            cell.accessoryType = .disclosureIndicator
            let name = NSLocalizedString("Title Text Color", comment: "") + " :"
            let color = self.coordinator?.graph.titleColor
            cell.setValueName(name, color: color)
            return cell
        }
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StaticValueCell", for: indexPath) as! StaticTextTableViewCell
            
            let nameString = NSLocalizedString("Font", comment: "") + " :"
            var valueString = self.coordinator?.graph.titleFontName
            let systemFontName = systemBoldFontName
            if valueString == systemFontName {
                valueString = NSLocalizedString("System Bold Font", comment: "")
            }
            cell.setValueName(nameString, value: valueString)
            return cell
        }
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DoubleValueCell", for: indexPath) as! DoubleValueInputTableViewCell
            cell.accessoryType = .none
            let nameString = NSLocalizedString("Font Size", comment: "") + " :"
            let value = self.coordinator?.graph.titleFontSize
            cell.valueFieldChangeDelegate = self
            cell.setValueName(nameString, value: value)
            return cell
        }
        if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ColorCell", for: indexPath) as! ColorSelectionTableViewCell
            cell.accessoryType = .disclosureIndicator
            let name = NSLocalizedString("Background Color", comment: "") + " :"
            let color = self.coordinator?.graph.backgroundColor
            cell.setValueName(name, color: color)
            return cell
        }
        if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StaticValueCell", for: indexPath) as! StaticTextTableViewCell
            
            let nameString = NSLocalizedString("Type", comment: "") + " :"
            let valueString = PlaygroundGraphType.None.rawValue
            cell.setValueName(nameString, value: valueString)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 1 {
            let pickerViewController = ColorPickerViewController()
            pickerViewController.fromIndexPath = indexPath
            pickerViewController.tableColorDelegate = self
            self.navigationController?.pushViewController(pickerViewController, animated: true)
        }
        if indexPath.section == 0 && indexPath.row == 2 {
            let pickerViewController = FontSelectionTableViewController(style: .plain)
            pickerViewController.selectionDelegate = self
            self.navigationController?.pushViewController(pickerViewController, animated: true)
        }
        if indexPath.section == 0 && indexPath.row == 4 {
            let pickerViewController = ColorPickerViewController()
            pickerViewController.fromIndexPath = indexPath
            pickerViewController.tableColorDelegate = self
            self.navigationController?.pushViewController(pickerViewController, animated: true)
        }
        if indexPath.section == 0 && indexPath.row == 5 {
            self.coordinator!.selectGraphType()
        }
    }
    
    @objc func cancelled() {
        self.coordinator?.cancel()
    }
    
    @objc func save() {
        self.coordinator?.save()
    }
}
