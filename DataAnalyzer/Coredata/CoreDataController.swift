//
//  CoreDataController.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 31.03.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import CoreData
import UIKit

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
                    writeDefaults(inContext: shared.managedObjectContext)
                    completionClosure(shared)
                }
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }
    
    private class func writeDefaults(inContext: NSManagedObjectContext) {
        
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
            let settings = try inContext.fetch(fetchRequest) as! [Settings]
            if settings.first == nil {
                let settingsObject = NSEntityDescription.insertNewObject(forEntityName: "Settings", into: CoreDataController.shared.managedObjectContext) as! Settings
                
                settingsObject.pgYAxisTextColor = UIColor.black
                settingsObject.pgXAxisTextColor = UIColor.black
                settingsObject.pgNormalLineWidth = Double(2.0)
                settingsObject.pgNormalLineColor = UIColor.red
                settingsObject.pgCircleColor = UIColor(red: 140.0/255.0, green: 234.0/255.0, blue: 255.0/255.0, alpha: 1.0)
                settingsObject.pgBackgroundColor = UIColor.red
                settingsObject.dgYAxisTextColor = UIColor.black
                settingsObject.dgXAxisTextColor = UIColor.black
                settingsObject.dgNormalLineWidth = Double(2.0)
                settingsObject.dgNormalLineColor = UIColor.brown
                settingsObject.dgFrequencyLineWidth = Double(2.0)
                settingsObject.dgFrequencyLineColor = UIColor.white
                settingsObject.dgBarColor = UIColor(red: 140.0/255.0, green: 234.0/255.0, blue: 255.0/255.0, alpha: 1.0)
                settingsObject.dgBackgroundColor = UIColor.white
                
                
                let maxRed = CGFloat(94.0/255.0)
                let maxGreen = CGFloat(15.0/255.0)
                let maxBlue = CGFloat(32.0/255.0)
                
                
                let minRed = CGFloat(17.0/255.0)
                let minGreen = CGFloat(49.0/255.0)
                let minBlue = CGFloat(94.0/255.0)
                
                let maxColor = UIColor(red: maxRed, green: maxGreen, blue: maxBlue, alpha: 1.0)
                let minColor = UIColor(red: minRed, green: minGreen, blue: minBlue, alpha: 1.0)
                
                settingsObject.heatmapMaxColor = maxColor
                settingsObject.heatmapMinColor = minColor
                settingsObject.heatmapValuesVisible = true
                
                try inContext.save()
            }
            
        }
        catch {
            
        }
        
    }
}
