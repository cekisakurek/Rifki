//
//  AddGraphViewController.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 31.03.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit
import CoreData

class AddGraphViewController: UIViewController {
    
    
    private var urlTextField: UITextView!
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.lightGray
        
        let addItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveGraph))
        self.navigationItem.rightBarButtonItem = addItem
        
        urlTextField = UITextView(frame: .zero)
        urlTextField.translatesAutoresizingMaskIntoConstraints = false
        
        
        let fetchButton = UIButton(type: .roundedRect)
        fetchButton.setTitle(NSLocalizedString("Fetch", comment: ""), for: .normal)
        fetchButton.translatesAutoresizingMaskIntoConstraints = false
        fetchButton.backgroundColor = UIColor.blue
        fetchButton.setTitleColor(UIColor.white, for: .normal)
        
        self.view.addSubview(urlTextField)
        
        
        let defaultConstraints = [
            urlTextField.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 50),
            urlTextField.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor, constant: 50),
//            urlTextField.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: 50),
            urlTextField.heightAnchor.constraint(equalToConstant: 100),
            urlTextField.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor, constant: -50)
        ]
        
        NSLayoutConstraint.activate(defaultConstraints)
        
        
        urlTextField.text = Bundle(for: type(of: self)).url(forResource: "train", withExtension: "csv")?.absoluteString
        
    }
    
    @objc func saveGraph() {
        
//        let url = URL(string: urlTextField.text)!
//        let csvOP = CSVOperation(url: url)
//        
//        csvOP.completionBlock =
//        {
//            
//            
//            let graph = NSEntityDescription.insertNewObject(forEntityName: "GraphData", into: CoreDataController.shared.managedObjectContext) as! GraphData
//            
//            
//            
//            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//
//                
//                let uuid = UUID().uuidString
//                let fileURL = dir.appendingPathComponent(uuid)
//
//                if (csvOP.result! as NSArray).write(to: fileURL, atomically: true) {
//                    graph.date = Date()
//                    graph.remoteURL = csvOP.url.absoluteString
//                    graph.localURL = uuid
//                }
//            }
//            
//            do {
//                try CoreDataController.shared.managedObjectContext.save()
//                self.dismiss(animated: true) {
//                    
//                }
//            }
//            catch {
//                
//            }
//        
//            
//        }
//        let importQueue = ImportOperationQueue()
//        
//        importQueue.queue.addOperation(csvOP)
    }
}

