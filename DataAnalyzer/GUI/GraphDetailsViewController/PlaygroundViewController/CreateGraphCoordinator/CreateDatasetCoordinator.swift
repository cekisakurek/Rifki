//
//  CreateDatasetTableViewController.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 11.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit

class CreateDatasetTableViewController: UITableViewController, PlaygroundGraphValueSelectionDelegate {
    
    weak var coordinator: CreateDatasetCoordinator?
    
    var selectedXAxis: Selectable?
    var selectedYAxis: Selectable?
    
    
    
    override func loadView() {
        super.loadView()
        
        self.tableView.estimatedRowHeight = 100.0;
//        self.tableView.register(NameInputTableViewCell.self, forCellReuseIdentifier: "NameCell")
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StaticValueCell", for: indexPath) as! StaticTextTableViewCell
        
        if indexPath.row == 0 {
            let nameString = NSLocalizedString("X Axis", comment: "") + " :"
            let valueString = selectedXAxis?.value as? String
            cell.setValueName(nameString, value: valueString)
        }
        else {
            let nameString = NSLocalizedString("Y Axis", comment: "") + " :"
            let valueString = selectedYAxis?.value as? String
            cell.setValueName(nameString, value: valueString)
        }
        return cell
        
    }
//    
//    // MARK: - UITableViewDelegate
//    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        let selectionViewController = PlaygroundGraphValueSelectionTableView(style: .plain)
        selectionViewController.items = self.coordinator?.selectableItems()
        selectionViewController.selectionDelegate = self
        self.navigationController?.pushViewController(selectionViewController, animated: true)
        
    }
    func itemSelected(_ selected: Selectable) {
        let indexPath = self.tableView.indexPathForSelectedRow
        if indexPath?.row == 0 {
            selectedXAxis = selected
            
        }
        else if indexPath?.row == 1 {
            selectedYAxis = selected
        }
        self.tableView.reloadRows(at: [indexPath!], with: .automatic)
        if selectedXAxis != nil && selectedYAxis != nil {
            
            let nextItem = UIBarButtonItem(title: NSLocalizedString("Next", comment: ""), style: .plain, target: self, action: #selector(advance))
            self.navigationItem.rightBarButtonItem = nextItem
        }
        else {
            self.navigationItem.rightBarButtonItem = nil
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
    
    func setAxisNames(x: String, y: String) {
        let set = GraphDataSet()
        set.xAxisName = x
        set.yAxisName = y
        self.graph.datasets.append(set)
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
                    
                    graphObject.name = self.graph.name
                    graphObject.createdDate = Date()
                    graphObject.type = self.graph.type.rawValue
                    graphObject.workset = selectedSet
                    
                    for set in self.graph.datasets {
                        let graphData = NSEntityDescription.insertNewObject(forEntityName: "GraphData", into: CoreDataController.shared.managedObjectContext) as! GraphData
                        graphData.xAxis = set.xAxisName
                        graphData.yAxis = set.yAxisName
                        graphObject.addToData(graphData)
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
