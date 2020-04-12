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
    
}


class PlaygroundGraph {
    var name: String!
    var type: PlaygroundGraphType = .None
    var datasets: [GraphDataSet] = [GraphDataSet]()
    var uuid: String!
    var availableHeaders: [String]!
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
// , PlaygroundGraphDetailsDelegate, PlaygroundGraphDetailsDatasource
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
    
    func setGraphName(_ name: String?) {
        self.graph.name = name
    }
}

class CreateGraphNameTypeViewController: UITableViewController, ObjectNamingProtocol {
    
    func objectNameFieldChanged(toString: String?) {
        self.coordinator?.setGraphName(toString)
    }
    
    
    var items: [Selectable]!
    weak var coordinator: CreateGraphCoordinator?
    
    override func loadView() {
        super.loadView()
        
        let cancelItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(cancelled))
        self.navigationItem.leftBarButtonItem = cancelItem
        
//        let saveItem = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .plain, target: self, action: #selector(save))
//        self.navigationItem.rightBarButtonItem = saveItem
        
        self.tableView.estimatedRowHeight = 100.0;
        self.tableView.register(NameInputTableViewCell.self, forCellReuseIdentifier: "NameCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.register(StaticTextTableViewCell.self, forCellReuseIdentifier: "StaticValueCell")
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
        
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as! NameInputTableViewCell
            cell.setName("New Graph")
            cell.nameFieldChangeDelegate = self
            return cell
        }
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StaticValueCell", for: indexPath) as! StaticTextTableViewCell
            
            let nameString = NSLocalizedString("Type", comment: "") + " :"
            let valueString = PlaygroundGraphType.None.rawValue // self.graphDetailsDatasource!.graphType().rawValue
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
