//
//  SavedGraphsViewController.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 31.03.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit
import CoreData

class DatasetsViewController: UITableViewController, NSFetchedResultsControllerDelegate {
        
    var fetchedResultsController: NSFetchedResultsController<GraphData>!
    
    var parseQueue = ImportOperationQueue()
    
    override func loadView() {
        
        super.loadView()
        self.title = NSLocalizedString("Datasets", comment: "")
        
        self.splitViewController?.preferredDisplayMode = .allVisible
        
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGraph))
        self.navigationItem.rightBarButtonItem = addItem
        
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        loadSavedData()

    }
    
    func loadSavedData() {
        
        if self.fetchedResultsController == nil {
            let request: NSFetchRequest<GraphData> = GraphData.fetchRequest()
            let sort = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [sort]
            request.fetchBatchSize = 20

            self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                        managedObjectContext: CoreDataController.shared.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            self.fetchedResultsController.delegate = self

            do {
                try self.fetchedResultsController.performFetch()
                self.tableView.reloadData()
            } catch {
                print("Fetch failed")
            }
        }
    }
    
    // MARK: - UITableViewDatasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let fetchedResultsController = fetchedResultsController,
            let sectionInfo = fetchedResultsController.sections?[0]{
            
            return sectionInfo.numberOfObjects
        }
        else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let graph = fetchedResultsController.object(at: indexPath)
        if let name = graph.name {
            cell.textLabel?.text = name
        }
        else {
            cell.textLabel?.text = graph.localURL
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.collapseDetailViewController = false
        
        let graph = fetchedResultsController.object(at: indexPath)

        if self.splitViewController!.viewControllers.count > 1 {
            // splittable
            if let splitDelegate = self.splitViewController?.delegate as? SplitViewDelegate {
                let parseCSVOperation = CSVParseOperation(uuid: graph.localURL!, delimiter: graph.delimiter!)
                
                parseCSVOperation.completionBlock =
                {
                        DispatchQueue.main.sync {
                            
                            if parseCSVOperation.error == nil {
                                splitDelegate.graphDetailsViewController?.dataset  = parseCSVOperation.result
                            }
                        }
                }
                
                parseQueue.queue.addOperation(parseCSVOperation)
            }
        }
        else {
//            if let splitDelegate = self.splitViewController?.delegate as? SplitViewDelegate,
//                let navigationController = self.splitViewController?.viewControllers[0] as? UINavigationController {
//                let parseCSVOperation = CSVParseOperation(uuid: graph.localURL!, delimiter: graph.delimiter!)
//                parseCSVOperation.completionBlock =
//                { [weak self] in
//                        DispatchQueue.main.sync {
//
//                            let detailsViewController = GraphDetailsViewController()
//                            detailsViewController.dataset = parseCSVOperation.result
//
////                            splitDelegate.graphDetailsViewController?.dataset  = parseCSVOperation.result
//                            navigationController.pushViewController(detailsViewController, animated: true)
//                            //                    graphDetailsViewController.dataset = parseCSVOperation.result
////                            self?.hide()
//                            //                    self?.splitViewController?.toggleMasterView()
//                        }
//                }
//
//                parseQueue.queue.addOperation(parseCSVOperation)
//
//
//            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//    }
    
//    override func tableView(_ tableView: UITableView,
//                            leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
//    {
//        let editAction = UIContextualAction(style: .normal, title:  "Edit", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
//            success(true)
//        })
//        editAction.backgroundColor = .blue
//
//        return UISwipeActionsConfiguration(actions: [editAction])
//    }
    
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        
        let editAction = UIContextualAction(style: .normal, title:  "Edit", handler: {
            [weak self] (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            
            let graph = self?.fetchedResultsController.object(at: indexPath)
            
            let detailsViewController = DatasetConfigurationViewController()
            detailsViewController.dataset = graph
            self?.navigationController?.pushViewController(detailsViewController, animated: true)
            
            success(true)
        })
        editAction.backgroundColor = .blue
        
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: {
            [weak self]  (ac:UIContextualAction, view:UIView, success: (Bool) -> Void) in
            
            let graph = self?.fetchedResultsController.object(at: indexPath)
            
            graph?.deleteFile()
            
            
            success(true)
        })
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    // MARK: - Other Functions
    
    @objc func addGraph() {
        
        (self.splitViewController as! DASplitViewController).showAddDatasetDialog()
    }
}

