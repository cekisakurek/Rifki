//
//  AddDataSetController.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 08.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit
import CoreData
import CoreServices

class ImportDatasetSettingsViewController: UITableViewController, DelimiterSelectionDelegate, DatasetNamingProtocol {
    
    
    weak var controller: AddDataSetController?
    var fileURL: URL?
    
    var currentDelimiter = comma
    var datasetName = "New Dataset"
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.white

        self.title = NSLocalizedString("Import", comment: "")

        
        self.tableView.estimatedRowHeight = 100.0;
        self.tableView.register(DatasetNameTableViewCell.self, forCellReuseIdentifier: "NameCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.register(DatasetStaticTextTableViewCell.self, forCellReuseIdentifier: "StaticValueCell")
        
        let closeItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
        self.navigationItem.leftBarButtonItem = closeItem
        
        let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveGraph))
        self.navigationItem.rightBarButtonItem = saveItem
        
        
    }
    
    @objc func saveGraph() {
        
        if let controller = controller {
            controller.importDataset(name: datasetName, url: self.fileURL!, delimiter: currentDelimiter.value)
        }
    }
    
    @objc func close() {
        
        self.dismiss(animated: true) {
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as! DatasetNameTableViewCell
                cell.nameFieldChangeDelegate = self
                return cell
                
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "StaticValueCell", for: indexPath) as! DatasetStaticTextTableViewCell
                cell.accessoryType = .disclosureIndicator
                let nameString = NSLocalizedString("Delimiter", comment: "") + " :"
                let valueString = " '\(currentDelimiter.name)' "
                cell.setValueName(nameString , value: valueString)
                
                return cell
                
                
            default:
                break
            }
        default:
            break
        }
        return tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 1 {
            let viewController = DelimiterSelectionTableView()
            viewController.selectionDelegate = self
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    func delimiterSelected(delimiter: Delimiter) {
        
        currentDelimiter = delimiter
        
        tableView.reloadData()
    }
    
    func datasetNameFieldChanged(toString: String?) {
        if let newName = toString {
            datasetName = newName
        }
    }
}

protocol AddDatasetViewControllerDelegate: UIViewController {
    
    func addDatasetController(_ controller: AddDataSetController, didAddDatasetAtURL: URL)
    func addDatasetControllerCancelled(_ controller: AddDataSetController)
}


class AddDataSetController: NSObject, UIDocumentPickerDelegate {
    
    var dataSetSettingsViewController: ImportDatasetSettingsViewController?
    var fileURL: URL?
    
    var fromViewController: AddDatasetViewControllerDelegate?
    
    func showImportDialog(fromViewController: AddDatasetViewControllerDelegate) {
        
        
        self.fromViewController = fromViewController
        
        let controller = UIDocumentPickerViewController(documentTypes: [kUTTypeCommaSeparatedText as String], in: .open)
//        let dialogNavigationController = UINavigationController(rootViewController: controller)
        controller.delegate = self
        fromViewController.present(controller, animated: true, completion: {

        })
        
//        #if targetEnvironment(macCatalyst)
//        let controller = CSVDocumentPickerViewController(forOpeningFilesWithContentTypes: ["csv"])
//        controller.delegate = self
//        fromViewController.present(controller, animated: true, completion: {
//
//        })
//
//        #else
//        let viewController = AddGraphViewController()
//        let navigationController = UINavigationController(rootViewController: viewController)
////        self.splitViewController?.present(navigationController, animated: true, completion: {
////
////        })
//        #endif
    }
    
    func showSettings() {
        dataSetSettingsViewController = ImportDatasetSettingsViewController()
        dataSetSettingsViewController?.controller = self
        dataSetSettingsViewController?.fileURL = self.fileURL
        
        let navigationController = UINavigationController(rootViewController: dataSetSettingsViewController!)
        navigationController.modalPresentationStyle = .formSheet
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            [weak self] in
            self?.fromViewController!.present(navigationController, animated: true) {

            };
        }
        
    }
    
    func importDataset(name: String, url: URL, delimiter: String = ",") {
        _ = url.startAccessingSecurityScopedResource()
        let importOperation = CSVImportOperation(url: url, delimiter: delimiter, name: name)
        importOperation.completionBlock =
        {
            DispatchQueue.main.sync {
                [weak self] in
                self?.dataSetSettingsViewController?.dismiss(animated: true, completion: {
                    url.stopAccessingSecurityScopedResource()
                    if let self = self {
                        self.fromViewController?.addDatasetController(self, didAddDatasetAtURL: url)
                    }
                    
                })
            }
        }
        let importQueue = ImportOperationQueue()
        
        importQueue.queue.addOperation(importOperation)
    }
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first {
            self.fileURL = url
            controller.dismiss(animated: true) {
                [weak self] in
                self?.showSettings()
            }
        }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.fromViewController?.addDatasetControllerCancelled(self)
    }
}
