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
    
    private(set) var persistentContainer: NSPersistentContainer!
    
    var writeContext: NSManagedObjectContext {
        get {
            return CoreDataController.shared.persistentContainer.newBackgroundContext()
        }
    }
    
    var viewContext: NSManagedObjectContext {
        get {
            return CoreDataController.shared.persistentContainer.viewContext
        }
    }
    
    class func start(completionClosure: @escaping (CoreDataController) -> ()) {
        
        ColorValueTransformer.register()
        
        let container = NSPersistentContainer(name: "Graphs")
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            else {
                container.viewContext.automaticallyMergesChangesFromParent = true
                CoreDataController.shared.persistentContainer = container
                writeDefaults(inContext: shared.writeContext)
                completionClosure(shared)
            }
        })
    }
    
    private class func writeDefaults(inContext: NSManagedObjectContext) {
        
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
            let settings = try inContext.fetch(fetchRequest) as! [Settings]
            if settings.first == nil {
                let settingsObject = NSEntityDescription.insertNewObject(forEntityName: "Settings", into: inContext) as! Settings
                
                settingsObject.pgYAxisTextColor = UIColor.black
                settingsObject.pgXAxisTextColor = UIColor.black
                settingsObject.pgNormalLineWidth = Double(2.0)
                settingsObject.pgNormalLineColor = UIColor.red
                settingsObject.pgCircleColor = UIColor(red: 140.0/255.0, green: 234.0/255.0, blue: 255.0/255.0, alpha: 1.0)
                settingsObject.pgBackgroundColor = UIColor.white
                settingsObject.dgYAxisTextColor = UIColor.black
                settingsObject.dgXAxisTextColor = UIColor.black
                settingsObject.dgNormalLineWidth = Double(2.0)
                settingsObject.dgNormalLineColor = UIColor.brown
                settingsObject.dgFrequencyLineWidth = Double(2.0)
                settingsObject.dgFrequencyLineColor = UIColor.red
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
            fatalError("Unresolved error \(error)")
        }
    }
}
