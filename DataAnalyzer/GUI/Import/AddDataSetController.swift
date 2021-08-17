//
//  AddDataSetController.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 28.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit
import CoreData
import CoreServices
import UniformTypeIdentifiers

protocol AddDatasetViewControllerDelegate: UIViewController {
    
    func addDatasetController(_ controller: AddDataSetController, didAddDatasetAtURL: URL)
    func addDatasetControllerCancelled(_ controller: AddDataSetController)
}

class AddDataSetController: NSObject, UIDocumentPickerDelegate {
    
    var dataSetSettingsViewController: ImportLocalDatasetSettingsViewController?
    var fileURL: URL?
    
    var fromViewController: AddDatasetViewControllerDelegate?
    
    func showImportDialog(fromViewController: AddDatasetViewControllerDelegate) {
        
        self.fromViewController = fromViewController
        

        if #available(iOS 14.0, *) {
            let supportedTypes: [UTType] = [UTType.commaSeparatedText]
            let controller = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
            controller.delegate = self
            
            let navigationController = UINavigationController(rootViewController: controller)
            fromViewController.present(navigationController, animated: true, completion: { })
        } else {
            // Fallback on earlier versions
            let controller = UIDocumentPickerViewController(documentTypes: [kUTTypeCommaSeparatedText as String], in: .open)
            controller.delegate = self
            fromViewController.present(controller, animated: true, completion: { })
        }
    }
    
    func showSettings() {
        dataSetSettingsViewController = ImportLocalDatasetSettingsViewController()
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
    
    // MARK: - UIDocumentPickerDelegate
    
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
    
    // MARK: - Importing
    
    func importDataset(name: String, url: URL, delimiter: String = ",", hasHeader: Bool = true) {
        _ = url.startAccessingSecurityScopedResource()
        let importOperation = CSVImportOperation(url: url, delimiter: delimiter, name: name, hasHeader: hasHeader)
        importOperation.completionBlock = {
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
        ImportOperation().queue.addOperation(importOperation)
    }
}
