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


class PlaygroundGraph {
    var name: String?
    var type: PlaygroundGraphType = .None
    var datasets: [GraphDataSet] = [GraphDataSet]()
    var uuid: String!
    var availableHeaders: [String]!
    
    var titleFontSize: Double = 24.0
    
    var titleFontName: String = UIFont.boldSystemFont(ofSize: 24).fontName
    var titleColor: UIColor = UIColor.black
    
    var backgroundColor: UIColor = UIColor.white
    
    var xAxisDisplayName: String?
    var yAxisTextFontSize: Double = 18.0
    var yAxisTextFontName: String = UIFont.systemFont(ofSize: 18.0).fontName
    var yAxisTextColor: UIColor = UIColor.black
    
    var yAxisDisplayName: String?
    var xAxisTextFontSize: Double = 18.0
    var xAxisTextFontName: String = UIFont.systemFont(ofSize: 18.0).fontName
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
        self.presentViewController.present(navigationController, animated: true) {

        }
    }
    
    func cancel() {
        self.rootViewController.dismiss(animated: true) {
            
        }
    }
    
    func save() {
        self.rootViewController.dismiss(animated: true) {
            
        }
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

class CreateGraphNameTypeViewController: UITableViewController, ObjectNamingProtocol, ColorPickerFromTableViewDelegate, UIFontPickerViewControllerDelegate {
    
    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        // attempt to read the selected font descriptor, but exit quietly if that fails
//        guard let descriptor = viewController.selectedFontDescriptor else { return }

//        let font = UIFont(descriptor: descriptor, size: 36)
//        yourLabel.font = font
    }
    
    func colorPicker(_ picker: ColorPickerViewController, didChange color: UIColor, forIndexPath: IndexPath) {
        if forIndexPath.row == 1 {
            self.coordinator?.graph.titleColor = color
        }
        else if forIndexPath.row == 2 {
            self.coordinator?.graph.backgroundColor = color
        }
        
        tableView.reloadData()
    }
    
    
    func objectNameFieldChanged(toString: String?) {
        self.coordinator?.graph.name = toString
    }
    
    
    var items: [Selectable]!
    weak var coordinator: CreateGraphCoordinator?
    
    override func loadView() {
        super.loadView()
        
        let cancelItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(cancelled))
        self.navigationItem.leftBarButtonItem = cancelItem
    
        self.tableView.estimatedRowHeight = 100.0;
        self.tableView.register(NameInputTableViewCell.self, forCellReuseIdentifier: "NameCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.register(StaticTextTableViewCell.self, forCellReuseIdentifier: "StaticValueCell")
        self.tableView.register(ColorSelectionTableViewCell.self, forCellReuseIdentifier: "ColorCell")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
        
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
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
            let valueString = NSLocalizedString("System Font", comment: "")
            cell.setValueName(nameString, value: valueString)
            return cell
        }
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ColorCell", for: indexPath) as! ColorSelectionTableViewCell
            cell.accessoryType = .disclosureIndicator
            let name = NSLocalizedString("Background Color", comment: "") + " :"
            let color = self.coordinator?.graph.backgroundColor
            cell.setValueName(name, color: color)
            return cell
        }
        if indexPath.row == 4 {
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
            let pickerViewController = UIFontPickerViewController()
//            pickerViewController.delegate = self
//            pickerViewController.fromIndexPath = indexPath
//            pickerViewController.tableColorDelegate = self
//            self.navigationController?.pushViewController(pickerViewController, animated: true)
            present(pickerViewController, animated: true)
        }
        if indexPath.section == 0 && indexPath.row == 3 {
            let pickerViewController = ColorPickerViewController()
            pickerViewController.fromIndexPath = indexPath
            pickerViewController.tableColorDelegate = self
            self.navigationController?.pushViewController(pickerViewController, animated: true)
        }
        if indexPath.section == 0 && indexPath.row == 4 {
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


class FontPickerContainerViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.white
        
        let pickerViewController = UIFontPickerViewController()
        pickerViewController.view.frame = self.view.bounds
        self.view.addSubview(pickerViewController.view)
    }
}
