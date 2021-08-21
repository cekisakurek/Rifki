//
//  PlaygroundViewModel.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 19.08.21.
//  Copyright © 2021 cekisakurek. All rights reserved.
//

import Combine
import CoreData

class PlaygroundViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    
    private var fetchedResultsController: NSFetchedResultsController<Graph>!
    var objectID: NSManagedObjectID?
    
    @Published var items: [PlaygroundGraphItem]?
    @Published var graphIndices: [Int]?
    
    override init() {
        super.init()
    }
    
    func getGraphs(from objectID: NSManagedObjectID?) {
        
        let context = PersistenceController.shared.viewContext
        if let objectID = objectID,
           let dataset = Dataset.fetch(in: context, objectID: objectID){
            do {
                let request: NSFetchRequest<Graph> = Graph.fetchRequest()
                let sort = NSSortDescriptor(key: "createdDate", ascending: false)
                let predicate = NSPredicate(format: "workset == %@", dataset)
                request.sortDescriptors = [sort]
                request.fetchBatchSize = 20
                request.predicate = predicate

                self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                           managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
                self.fetchedResultsController.delegate = self
                try self.fetchedResultsController.performFetch()
                

                var items = [PlaygroundGraphItem]()
                items.append(PlaygroundGraphItem(index: -1))

                if let result = self.fetchedResultsController.fetchedObjects {
                    for (index, graph) in result.enumerated() {
                        let item = PlaygroundGraphItem(index: index, graph: graph)
                        items.append(item)
                    }
                }
                self.items = items
            }
            catch {
                //TODO: Correct error handling
                print("Fetch failed")
            }
        }
    }
    
    struct PlaygroundGraphItem: Identifiable {
        var id = UUID()
        var index: Int
        var graph: Graph?
    }
}
