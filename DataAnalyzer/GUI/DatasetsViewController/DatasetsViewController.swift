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
        
    var fetchedResultsController: NSFetchedResultsController<Dataset>!
    
    var parseQueue = ImportOperationQueue()
    
    var loadedDatasetUUID: String?
    
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
            let request: NSFetchRequest<Dataset> = Dataset.fetchRequest()
            let sort = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [sort]
            request.fetchBatchSize = 20

            self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                        managedObjectContext: CoreDataController.shared.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            self.fetchedResultsController.delegate = self

            do {
                try self.fetchedResultsController.performFetch()
                self.tableView.reloadData()
            }
            catch {
                ErrorAlertView.showError(with: String(describing: error), from: self)
            }
        }
    }
    
    // MARK: - UITableViewDatasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let fetchedResultsController = fetchedResultsController,
            let sectionInfo = fetchedResultsController.sections?[section]{
            
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
            cell.textLabel?.text = graph.uuid
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.parseAndPushGraph(at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
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
        editAction.backgroundColor = UIColor.blue.withAlphaComponent(0.7)
        
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: {
            [weak self]  (ac:UIContextualAction, view:UIView, success: (Bool) -> Void) in
            
            let graph = self?.fetchedResultsController.object(at: indexPath)
            
            do {
                try graph?.deleteFile()
            }
            catch {
                ErrorAlertView.showError(with: String(describing: error), from: self!)
            }
            
            success(true)
        })
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if type == .delete {
            
            if let graph = anObject as? Dataset,
                graph.uuid == self.loadedDatasetUUID {
                
                if let splitDelegate = self.splitViewController?.delegate as? SplitViewDelegate {
                    splitDelegate.graphDetailsViewController?.dataset  = nil
                }
            }
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        DispatchQueue.main.async {
            [weak self] in
            
            guard let self = self else {
                return
            }
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Other Functions
    
    func parseAndPushGraph(at indexPath: IndexPath) {
        let graph = fetchedResultsController.object(at: indexPath)

        if self.splitViewController!.viewControllers.count > 1 {
            // splittable
            if let splitDelegate = self.splitViewController?.delegate as? SplitViewDelegate {
                let parseCSVOperation = CSVParseOperation(uuid: graph.uuid!, delimiter: graph.delimiter!)
                splitDelegate.graphDetailsViewController?.loadingDataset()
                parseCSVOperation.completionBlock =
                {
                    [weak self] in
                    
                    DispatchQueue.main.sync {
                        
                        if parseCSVOperation.error == nil {
                            
                            self?.loadedDatasetUUID = graph.uuid!
                            splitDelegate.graphDetailsViewController?.datasetLoaded()
                            splitDelegate.graphDetailsViewController?.dataset  = parseCSVOperation.result
                        }
                        else {
                            ErrorAlertView.showError(with: String(describing: parseCSVOperation.error), from: self!)
                        }
                    }
                }
                
                parseQueue.queue.addOperation(parseCSVOperation)
            }
        }
    }
    
    @objc func addGraph() {
        
        (self.splitViewController as! DASplitViewController).showAddDatasetDialog()
    }
}

