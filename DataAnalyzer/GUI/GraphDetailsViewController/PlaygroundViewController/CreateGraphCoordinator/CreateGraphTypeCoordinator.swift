//
//  CreateGraphTypeCoordinator.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 11.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit

class CreateGraphTypeCoordinator: Coordinator {
        
    override init() {
        super.init()
        let viewController = SelectGraphTypeViewController(style: .plain)
        viewController.coordinator = self
        viewController.title = NSLocalizedString("Select Type", comment: "")
        self.rootViewController = viewController
    }
    
    func start() {
        if let parentCoordinator = parentCoordinator as? CreateGraphCoordinator {
            (parentCoordinator.rootViewController as! UINavigationController).pushViewController(self.rootViewController, animated: true)
        }
    }
    
    func selectDataset(with graphType: PlaygroundGraphType) {
        
        let subCoordinator = CreateDatasetCoordinator(type: graphType)
        graph.type = graphType
        subCoordinator.graph = graph
        self.subCoordiantors.append(subCoordinator)
        subCoordinator.parentCoordinator = self
        subCoordinator.start()
    }
}

class SelectGraphTypeViewController: UITableViewController {
    
    weak var coordinator: CreateGraphTypeCoordinator?
    
    var items: [Selectable]!
    
    override func loadView() {
        super.loadView()

        let bar = Selectable(key: NSLocalizedString("Bar Graph", comment: ""), value: PlaygroundGraphType.Bar)
        let line = Selectable(key: NSLocalizedString("Line Graph", comment: ""), value: PlaygroundGraphType.Line)
        let scatter = Selectable(key: NSLocalizedString("Scatter Graph", comment: ""), value: PlaygroundGraphType.Scatter)
        
        self.items = [bar, line, scatter]
        
        self.tableView.estimatedRowHeight = 100.0;
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = item.key
        return cell
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let item = items[indexPath.row]
        self.coordinator!.selectDataset(with: item.value as! PlaygroundGraphType)
    }
}
