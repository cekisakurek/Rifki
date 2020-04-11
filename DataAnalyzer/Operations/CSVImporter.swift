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
    
    init(url: URL, delimiter: String, name: String) {
        
        self.url = url
        self.delimiter = delimiter
        self.datasetName = name
    }
    
    override func main() {
        
        if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let uuid = UUID().uuidString
            let fileURL = directory.appendingPathComponent(uuid)
            
            do {
//                if FileManager.default.fileExists(atPath: fileURL.path) {
//                    try FileManager.default.removeItem(at: fileURL)
//                }
//                try FileManager.default.copyItem(at: self.url, to: fileURL)
                
                let data = try Data(contentsOf: self.url)
                
                try data.write(to: fileURL)
                
                let graph = NSEntityDescription.insertNewObject(forEntityName: "GraphData", into: CoreDataController.shared.managedObjectContext) as! GraphData
                
                graph.date = Date()
                graph.remoteURL = self.url.absoluteString
                graph.localURL = uuid
                graph.delimiter = delimiter
                graph.name = self.datasetName
                try CoreDataController.shared.managedObjectContext.save()
                
            }
            catch {
                print(error)
            }
            
        }
    }
}

enum CSVParseOperationError: Error {
  case localFileNotFound
//  case noFamiliar
//  case familiarAlreadyAToad
//  case spellFailed(reason: String)
//  case spellNotKnownToWitch
}


class CSVParseOperation: Operation {
    
    private(set) var url: URL!
    private(set) var result: GraphRawData?
    private(set) var delimiter: String
    private(set) var error: CSVParseOperationError?
    
    init(uuid: String, delimiter: String) {
        
        if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        
            let fileURL = directory.appendingPathComponent(uuid)
            self.url = fileURL
        }
        
        
        self.delimiter = delimiter
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
            let csv = try! CSVReader(stream: stream, hasHeaderRow: true, delimiter: UnicodeScalar(self.delimiter)!)
            
//            var items: [[String]] = []
//
//            if let header = csv.headerRow {
//                items.append(header)
//            }
//
//            while let row = csv.next() {
//                print("\(row)")
//                items.append(row)
//            }
            
            let set = GraphRawData(reader: csv)
            
            self.result = set
            
//            let dataString = String(data: data, encoding: .utf8)!
//
//            var items: [[String]] = []
//            let lines: [String] = dataString.components(separatedBy: NSCharacterSet.newlines) as [String]
//            for line in lines {
//               var values: [String] = []
//               if line != "" {
//                   if line.range(of: "\"") != nil {
//                       var textToScan:String = line
//                       var value:String?
//                       var textScanner:Scanner = Scanner(string: textToScan)
//                    while !textScanner.isAtEnd {
//                           if (textScanner.string as NSString).substring(to: 1) == "\"" {
//
//
//                               textScanner.currentIndex = textScanner.string.index(after: textScanner.currentIndex)
//
//                               value = textScanner.scanUpToString("\"")
//                               textScanner.currentIndex = textScanner.string.index(after: textScanner.currentIndex)
//                           } else {
//                               value = textScanner.scanUpToString(",")
//                           }
//
//                            values.append(value! as String)
//
//                        if !textScanner.isAtEnd{
//                                let indexPlusOne = textScanner.string.index(after: textScanner.currentIndex)
//
//                            textToScan = String(textScanner.string[indexPlusOne...])
//                            } else {
//                                textToScan = ""
//                            }
//                            textScanner = Scanner(string: textToScan)
//                       }
//
//                       // For a line without double quotes, we can simply separate the string
//                       // by using the delimiter (e.g. comma)
//                   } else  {
//                       values = line.components(separatedBy: ",")
//                   }
//
//                   items.append(values)
//                }
//                self.result = items
//            }
        }
    }
}
