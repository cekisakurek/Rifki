//
//  CSVImporter.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 31.03.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import Foundation
import CSV
import CoreData

class CSVImportOperation: Operation {
    
    private(set) var url: URL!
    private(set) var result: [[String]]?
    private(set) var delimiter: String
    private(set) var datasetName: String
    private(set) var hasHeader: Bool
    
    init(url: URL, delimiter: String, name: String, hasHeader: Bool) {
        
        self.url = url
        self.delimiter = delimiter
        self.datasetName = name
        self.hasHeader = hasHeader
    }
    
    override func main() {
        
        if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let uuid = UUID().uuidString
            let fileURL = directory.appendingPathComponent(uuid)
            
            do {
                
                let data = try Data(contentsOf: self.url)
                
                try data.write(to: fileURL)
                let context = CoreDataController.shared.writeContext
                let graph = NSEntityDescription.insertNewObject(forEntityName: "Dataset", into: context) as! Dataset
                
                graph.date = Date()
                graph.remoteURL = self.url.absoluteString
                graph.uuid = uuid
                graph.delimiter = self.delimiter
                graph.name = self.datasetName
                graph.hasHeader = self.hasHeader
                
                try context.save()
            }
            catch {
                print(error)
            }
        }
    }
}

enum CSVParseOperationError: Error {
  case localFileNotFound
}

class DataAnalyseOperation: Operation {
    
    
    private(set) var warnings = [String]()
    
    private var data: GraphRawData!
    
    init(data: GraphRawData) {
        self.data = data
    }
    
    override func main() {
        
        if isCancelled {
            return
        }
        if let data = self.data {
            
            let rowCount = (data.rows.count)
            let columnCount = (data.headers?.count)!
            
            for i in 0..<columnCount {
                
                var uniqueStrings = Set<String>()
                var uniqueNumbers = Set<Float>()
                
                for j in 0..<rowCount {
                    let value = data.rows[j][i]
                    
                    if value is String {
                        
                        let str = value as! String
                        
                        if !str.isEmpty {
                            
                            if let number = Float(str) {
                                uniqueNumbers.insert(number)
                            }
                            else {
                                uniqueStrings.insert(str)
                            }
                        }
                    }
                }
                
                if uniqueNumbers.count > 0 && uniqueStrings.count > 0 {
                    let name = data.headers![i]
                    
                    let uniqueNumberString = "\(uniqueNumbers.count) unique number values"
                    let uniqueStringString = "\(uniqueStrings.count) unique string values"
                    
                    var warning = "\(name) has \(uniqueNumberString) and \(uniqueStringString)"
                    warning += " ["
                    
                    if uniqueStrings.count > uniqueNumbers.count {
                        let array = Array(uniqueNumbers)
                        for item in array {
                            warning += "\(item)"
                            if item != array.last {
                                warning += ","
                            }
                        }
                    }
                    else {
                        let array = Array(uniqueStrings)
                        for item in array {
                            warning += "\(item)"
                            if item != array.last {
                                warning += ","
                            }
                            
                        }
                    }
                    warning += "]"
                    self.warnings.append(warning)
                }
                 
            }
            
            
            
            
        }
        
//        if !data.isEmpty {
//            let stream = InputStream(url: self.url)!
//            let csv = try! CSVReader(stream: stream, hasHeaderRow: self.hasHeader, delimiter: UnicodeScalar(self.delimiter)!)
//
//            let set = GraphRawData(reader: csv)
//            set.uuid = self.uuid
//            self.result = set
//        }
    }
    
}


class CSVParseOperation: Operation {
    
    private(set) var url: URL!
    private(set) var result: GraphRawData?
    private(set) var delimiter: String
    private(set) var error: CSVParseOperationError?
    private(set) var uuid: String
    private(set) var hasHeader: Bool
    
    init(uuid: String, delimiter: String, hasHeader: Bool) {
        
        self.uuid = uuid
        if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        
            let fileURL = directory.appendingPathComponent(uuid)
            self.url = fileURL
        }
        self.delimiter = delimiter
        self.hasHeader = hasHeader
    }
    
    override func main() {
        
        if isCancelled {
            return
        }
        
        guard let data = try? Data(contentsOf: self.url) else {
            print("File at url: \(String(describing: self.url)) not found!")
            self.error = .localFileNotFound
            return
        }
        
        if isCancelled {
            return
        }
        
        if !data.isEmpty {
            let stream = InputStream(url: self.url)!
            let csv = try! CSVReader(stream: stream, hasHeaderRow: self.hasHeader, delimiter: UnicodeScalar(self.delimiter)!)
            
            let set = GraphRawData(reader: csv)
            set.uuid = self.uuid
            self.result = set
        }
    }
}
