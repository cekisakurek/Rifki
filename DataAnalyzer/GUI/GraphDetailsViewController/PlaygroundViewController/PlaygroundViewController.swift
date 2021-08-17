//
//  PlaygroundViewController.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 11.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit
import CoreData

extension PlaygroundViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

class PlaygroundViewController: UICollectionViewController {
    
    static let leftAndRightPaddings: CGFloat = 10.0
    
    private var fetchedResultsController: NSFetchedResultsController<Graph>!
    
    private var createGraphCoordinator: CreateGraphCoordinator?
    
    var dataset: GraphRawData? {
        didSet {
            self.collectionView.isHidden = dataset == nil

        }
    }
    
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
        self.collectionView.isHidden = true
        self.collectionView.register(AddGraphCollectionViewCell.self, forCellWithReuseIdentifier: "AddGraphCell")
        self.collectionView.register(GraphThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: "GraphThumbnailCell")
        
        loadSavedData()
    }
    
    func loadSavedData() {
        
        if self.fetchedResultsController == nil,
            let dataset = dataset {
            
            do {
                let context = CoreDataController.shared.viewContext
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
                                                                               managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
                    self.fetchedResultsController.delegate = self
                    try self.fetchedResultsController.performFetch()
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
        return cell
    }

    // MARK: - UICollectionViewDelegate protocol

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
}





