//
//  Dataset+Ext.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 17.08.21.
//  Copyright © 2021 cekisakurek. All rights reserved.
//

import CoreData
import SigmaSwiftStatistics

enum ColumnType: String {
    case Unknown = "Unknown"
    case Int = "Integer"
    case Double = "Double"
    case String = "String"
}

class ColumnAnalysis {
    private(set) var data: [String]
    
    private(set) var type: ColumnType = .Unknown
    
    private var cached: [Double]?
    private var cachedInt: [Int]?
    
    private(set) var name: String
    
    static func getColumnData(data: [[String]], index: Int) -> [Double] {
        
        var d = [Double]()
        
        for i in 0..<data.count {
            if let value = Double(data[i][index]) {
                d.append(value)
            }
            else {
                d.append(0.0)
            } 
        }
        return d
    }
    
    private func getType() -> ColumnType {
        
        var unknownTypeCount = 0
        var intTypeCount = 0
        var doubleTypeCount = 0
        var stringTypeCount = 0
        
        for (_, column) in data.enumerated() {
            let type = ColumnAnalysis.typeOf(value: column)
            switch type {
                case .Int:
                    intTypeCount += 1
                case .Double:
                    doubleTypeCount += 1
                case .String:
                    stringTypeCount += 1
                case .Unknown:
                    fallthrough
                default:
                    unknownTypeCount += 1
                    break
            }
        }
        
        if unknownTypeCount > (doubleTypeCount + intTypeCount + stringTypeCount) {
            return .Unknown
        }
        else if stringTypeCount > (doubleTypeCount + intTypeCount) {
            return .String
        }
        else if doubleTypeCount > intTypeCount {
            return .Double
        }
        else {
            return .Int
        }
    }
    
    init(data: [[String]], index: Int, name: String) {
        self.name = name
        var arr = [String]()
        
        for (_, row) in data.enumerated() {
            arr.append(row[index])
        }
        self.data = arr
        
        self.type = getType()
    }
    
    func dataAsStringArray() -> [String] {
        return self.data
    }
    
    func dataAsDoubleArray() -> [Double] {
        if let cached = self.cached {
            return cached
        }
        
        var d = [Double]()
        for (_, row) in self.data.enumerated() {
            if let c = Double(row) {
                d.append(c)
            }
            else {
                d.append(0.0)
            }
        }
        self.cached = d
        return d
    }
    
    func dataAsIntArray() -> [Int] {
        if let cachedInt = self.cachedInt {
            return cachedInt
        }
        
        var d = [Int]()
        for (_, row) in self.data.enumerated() {
            if let c = Int(row) {
                d.append(c)
            }
            else {
                d.append(0)
            }
        }
        self.cachedInt = d
        return d
    }
    
    private static func typeOf(value: String) -> ColumnType {
        
        let val = value.replacingOccurrences(of: ",", with: ".")
        
        if !val.isEmpty {
            if let f = Float(val) {
                if floor(f) == f {
                    return .Int
                }
                else {
                    return .Double
                }
            }
            else {
                return .String
            }
        }
        return .Unknown
    }
    
    func average() -> Double? {
        let data = dataAsDoubleArray()
        return Sigma.average(data)!
    }
    
    func standardDeviationSample() -> Double? {
        let data = dataAsDoubleArray()
        return Sigma.standardDeviationSample(data)!
    }
    
    func min() -> Double? {
        let data = dataAsDoubleArray()
        return Sigma.min(data)!
    }
    
    func twoFive() -> Double? {
        let data = dataAsDoubleArray()
        return Sigma.percentile(data, percentile: 0.25)
    }
    
    func fiveZero() -> Double? {
        let data = dataAsDoubleArray()
        return Sigma.percentile(data, percentile: 0.5)
    }
    
    func sevenFive() -> Double? {
        let data = dataAsDoubleArray()
        return Sigma.percentile(data, percentile: 0.75)
    }
    
    func max() -> Double? {
        let data = dataAsDoubleArray()
        return Sigma.max(data)
    }
    
    func skewnessB() -> Double? {
        let data = dataAsDoubleArray()
        return Sigma.skewnessB(data)
    }
    
    func kurtosisB() -> Double? {
        let data = dataAsDoubleArray()
        return Sigma.kurtosisB(data)
    }
    
    var swilkP: Double?
    var swilkW: Double?
    
}

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
        
    static func fetch(in context: NSManagedObjectContext, objectID: NSManagedObjectID) -> Dataset? {
        do {
            let request = makeRequest()
            request.predicate = NSPredicate(format: "self == %@", objectID)
            let result = try context.fetch(request)
            return result.first
        } catch {
            // TODO: correct exception handling
            print("Fetch failed")
        }
        return nil
    }
    
    func delete() throws {
        self.managedObjectContext?.delete(self)
        try self.managedObjectContext?.save()
    }
}

extension Graph {
    
    func delete() throws {
        self.managedObjectContext?.delete(self)
        try self.managedObjectContext?.save()
    }
}

