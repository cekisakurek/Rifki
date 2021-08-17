//
//  DASplitViewController.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 08.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit

class DASplitViewController: UISplitViewController, UIDropInteractionDelegate, AddDatasetViewControllerDelegate {
    
    var addDataSetController: AddDataSetController?
    
    func addDatasetController(_ controller: AddDataSetController, didAddDatasetAtURL: URL) {
        // We import the file in addDatasetController
        // no op
    }
    
    func addDatasetControllerCancelled(_ controller: AddDataSetController) {
        // no op
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showAddDatasetDialog() {
        addDataSetController = AddDataSetController()
        addDataSetController?.showImportDialog(fromViewController: self)
    }
    
    func showImportFromURLDialog(url: URL) {
        
        addDataSetController = AddDataSetController()
        addDataSetController?.fromViewController = self
        addDataSetController?.fileURL = url
        addDataSetController?.showSettings()
    }
}

class SplitViewDelegate: NSObject, UISplitViewControllerDelegate {
    
    weak var savedGraphsViewController: DatasetsViewController?
    weak var  graphDetailsViewController: GraphDetailsViewController?
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool
    {
        
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? GraphDetailsViewController else { return false }
        if topAsDetailController.dataset == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }
}

