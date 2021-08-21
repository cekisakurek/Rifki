//
//  ImportDatasetViewModel.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 20.08.21.
//  Copyright © 2021 cekisakurek. All rights reserved.
//

import CoreData
import CSV

class ImportDatasetViewModel: ObservableObject {
    
    @Published var importDone: Bool = false
    
    func save(url: URL, name: String, delimiter: String, hasHeader: Bool, completion: @escaping () -> ()) {
        _ = url.startAccessingSecurityScopedResource()
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            guard let self = self else { return }
            self._save(url: url, delimiter: delimiter, name: name, hasHeader: hasHeader)
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func _save(url: URL, delimiter: String, name: String, hasHeader: Bool) {
        let delimiterValue = Delimiter.delimiter(from: delimiter).value
        do {
            if let stream = InputStream(url: url),
               let reader = try? CSVReader(stream: stream, hasHeaderRow: hasHeader, delimiter: UnicodeScalar(delimiterValue)!){

                let context = PersistenceController.shared.writeContext
                let dataset = NSEntityDescription.insertNewObject(forEntityName: "Dataset", into: context) as! Dataset
                
                dataset.date = Date()
                dataset.uuid = UUID().uuidString
                
                dataset.delimiter = delimiterValue
                if name == "" {
                    dataset.name = NSLocalizedString("New dataset", comment: "")
                }
                else {
                    dataset.name = name
                }
                
                dataset.hasHeader = hasHeader
                
                var raw = [[String]]()
                while let row = reader.next() {
                    raw.append(row)
                }
                if let header = reader.headerRow {
                    dataset.headers = header
                }
                dataset.data = raw
                try context.save()
            }
            else {
                print("Input Stream @ \(url) cannot be opened")
            }
        }
        catch {
            print(error)
        }
    }
    
    struct Delimiter: Hashable, Identifiable {
        var id: String
        let value: String
        let name: String
        
        public static let comma = Delimiter(id: ",", value: ",", name: "comma ','")
        public static let semicolon = Delimiter(id: ";", value: ";", name: "semicolon ';'")
        public static let tab = Delimiter(id: "\t", value: "\t", name: "tab ' \\t' ")
        public static let colon = Delimiter(id: ":", value: ":", name: "colon ' : '")
        public static let pipe = Delimiter(id: "|", value: "|", name: "pipe '|'")
        
        static func delimiter(from name: String) -> Delimiter {
            if name == comma.name { return .comma }
            else if name == semicolon.name { return .semicolon }
            else if name == tab.name { return .tab }
            else if name == colon.name { return .colon }
            else if name == pipe.name { return .pipe }
            else { return .comma }
        }
    }
}
