//
//  CoreDataController.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 31.03.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import CoreData


class CoreDataController {
    
    // MARK: - Core Data stack
    
    static let shared = CoreDataController()
    
    var managedObjectContext: NSManagedObjectContext!
    
    var writeContext: NSManagedObjectContext!
    
//    private lazy var variable:SomeClass = {
//        let fVariable = SomeClass()
//        fVariable.value = 10
//        return fVariable
//    }()
    
//    init() {
//        guard let modelURL = Bundle.main.url(forResource: "Graphs", withExtension:"momd") else {
//            fatalError("Error loading model from bundle")
//        }
//        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
//        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
//            fatalError("Error initializing mom from: \(modelURL)")
//        }
//
//        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
//
//        managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
//        managedObjectContext.persistentStoreCoordinator = psc
//        managedObjectContext.automaticallyMergesChangesFromParent = true
//        //        container.viewContext.automaticallyMergesChangesFromParent = true
//        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
//        queue.async {
//            guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
//                fatalError("Unable to resolve document directory")
//            }
//            let storeURL = docURL.appendingPathComponent("DataModel.sqlite")
//            do {
//
//                let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
//                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
//                //The callback block is expected to complete the User Interface and therefore should be presented back on the main queue so that the user interface does not need to be concerned with which queue this call is coming from.
//                //                DispatchQueue.main.sync(execute: completionClosure)
////                DispatchQueue.main.sync {
////                    completionClosure(self)
////                }
//            } catch {
//                fatalError("Error migrating store: \(error)")
//            }
//        }
//    }
    

    class func start(completionClosure: @escaping (CoreDataController) -> ()) {
        //This resource is the same name as your xcdatamodeld contained in your project
        guard let modelURL = Bundle.main.url(forResource: "Graphs", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        
        shared.managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        
        
        shared.managedObjectContext.persistentStoreCoordinator = psc
        shared.managedObjectContext.automaticallyMergesChangesFromParent = true
        
//        container.viewContext.automaticallyMergesChangesFromParent = true
        
        shared.writeContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        
        shared.writeContext.parent = shared.managedObjectContext
        shared.writeContext.automaticallyMergesChangesFromParent = true
        
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        queue.async {
            guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
                fatalError("Unable to resolve document directory")
            }
            let storeURL = docURL.appendingPathComponent("DataModel.sqlite")
            do {
                let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
                //The callback block is expected to complete the User Interface and therefore should be presented back on the main queue so that the user interface does not need to be concerned with which queue this call is coming from.
//                DispatchQueue.main.sync(execute: completionClosure)
                DispatchQueue.main.sync {
                    completionClosure(shared)
                }
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }
}
