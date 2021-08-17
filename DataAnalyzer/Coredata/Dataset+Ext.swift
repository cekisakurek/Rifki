//
//  Dataset+Ext.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 17.08.21.
//  Copyright © 2021 cekisakurek. All rights reserved.
//

import CoreData

extension Dataset {
    static let entityName = "Dataset"
    
    convenience init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Self.entityName, in: context)!
        self.init(entity: entity, insertInto: context)
    }
    
    static func makeRequest() -> NSFetchRequest<Dataset> {
        return NSFetchRequest<Dataset>(entityName: entityName)
    }
    
    static func resultsController(context: NSManagedObjectContext, sortDescriptors: [NSSortDescriptor] = []) -> NSFetchedResultsController<Dataset> {
        let request = makeRequest()
        request.sortDescriptors = sortDescriptors.isEmpty ? nil : sortDescriptors
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
}


struct ManagedObjectContextChanges<T: NSManagedObject> {
    let inserted: Set<T>
    let deleted: Set<T>
    let updated: Set<T>
    
    init?(notification: Notification) {
        let unpack: (String) -> Set<T> = { key in
            let managedObjects = (notification.userInfo?[key] as? Set<NSManagedObject>) ?? []
            return Set(managedObjects.compactMap({ $0 as? T }))
        }
        deleted = unpack(NSDeletedObjectsKey)
        inserted = unpack(NSInsertedObjectsKey)
        updated = unpack(NSUpdatedObjectsKey).union(unpack(NSRefreshedObjectsKey))
        if deleted.isEmpty, inserted.isEmpty, updated.isEmpty {
            return nil
        }
    }
}

extension NSManagedObjectContext {
    func saveIfNeeded() {
        guard hasChanges else { return }
        do {
            try save()
        }
        catch let nsError as NSError {
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
