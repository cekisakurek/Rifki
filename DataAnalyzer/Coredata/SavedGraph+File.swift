//
//  SavedGraph+File.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 31.03.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import CoreData
import CSV
import UIKit

enum DatasetError: String, Error {
  case fileNotFound = "FileNotFound"
}

extension Graph {
    
    func delete() throws {
    
        self.managedObjectContext?.delete(self)
        try self.managedObjectContext?.save()
    }
}


extension Dataset {
    
    func loadRaw() -> [[String]]? {
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let uuid = self.uuid!
            let fileURL = dir.appendingPathComponent(uuid)

            let savedArray = NSArray(contentsOf: fileURL)
            
            return savedArray  as? [[String]]
            
        }
        
        return nil
    }
    
    
    func fileURL() -> URL? {
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let uuid = self.uuid!
            let fileURL = dir.appendingPathComponent(uuid)
            
            return fileURL
        }
        return nil
    }
    
    func deleteFile() throws {
    
        if let fileURL = self.fileURL() {
            
            try FileManager.default.removeItem(at: fileURL)
            self.managedObjectContext?.delete(self)
            try self.managedObjectContext?.save()
        }
        else {
            throw DatasetError.fileNotFound
        }
    }
}


enum GraphColumnDataType {
    case Unknown
    case Id
    case Number
    case DateTime
    case String
    
}

class GraphRawData {
    
    var raw :        [[String]]!
    var headers :    [String]?
    var rows :       [[Any]]!
    var hasHeader =  true
    var uuid :       String!
    
    init(reader: CSVReader) {
        
        var rows = [[Any]]()
        while let row = reader.next() {
            rows.append(row)
        }
        if let header = reader.headerRow {
            
            headers = header
        }
        self.rows = rows
    }
    
    func column(named: String) -> ([Any]?, GraphColumnDataType) {
        
        if let index = headers?.firstIndex(of: named) {
            return column(atIndex: index)
        }
        return (nil, .Unknown)
    }
    
    func column(atIndex: Int) -> ([Any], GraphColumnDataType) {
        
        let rows = self.rows
        var arr = [Any]()
        
        var type = GraphColumnDataType.Unknown
        
        for (_, row) in rows!.enumerated() {
            
            type = GraphRawData.typeOf(value: row[atIndex])
            switch type {
            case .Number:
                if let intValue = row[atIndex] as? String {
                    arr.append(Double(intValue)!)
                }
                else {
                    arr.append(Double(0.0))
                }
            default:
                arr.append(Double(0.0))
                break
            }
        }
        return (arr, type)
        
    }

    func typeOfColumn(columnIndex: Int) -> GraphColumnDataType {
        
        if columnIndex == 0 {
            return .Id
        }
        
        let rows = self.rows!
        for (_, row) in rows.enumerated() {
            let type = GraphRawData.typeOf(value: row[columnIndex])
            return type
        }
        return .Unknown
    }
    
    class func typeOf(value: Any) -> GraphColumnDataType {
     
        if value is String {
            
            let v = (value as! String).replacingOccurrences(of: ",", with: ".")
            
            let str = v
            
            if !str.isEmpty {
                
                if let _ = Float(str) {
                    
                    return .Number
                }
                else {
                    return .String
                }
            }
        }
        return .Unknown
    }
    
    class func typeOfData(data: [Any]) -> GraphColumnDataType {
        
        let rows = data
        for (_, row) in rows.enumerated() {
            
            if row is String {
                
                let str = row as! String
                
                if !str.isEmpty {
                    
                    if let floatValue = Float(str) {

                        if floatValue.isInteger {
                            // integer
                            return .Number
                        }
                    }
                    else {
                        return .String
                    }
                }
            }
        }
        return .Unknown
    }
}

extension FloatingPoint {
  var isInteger: Bool { rounded() == self }
}


class Document: UIDocument {
    
    override func contents(forType typeName: String) throws -> Any {
        // Encode your document with an instance of NSData or NSFileWrapper
        return Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load your document from contents
        print(contents)
    }
}
