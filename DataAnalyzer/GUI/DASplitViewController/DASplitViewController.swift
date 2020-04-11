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
        
    }
    
    func addDatasetControllerCancelled(_ controller: AddDataSetController) {
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.addInteraction(UIDropInteraction(delegate: self))
        
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
    
//    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
//        print(interaction)
//        return true
//    }
//
//    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
//      //only want external app sessions
//      if session.localDragSession == nil {
//        return UIDropProposal(operation: .copy)
//      }
//      return UIDropProposal(operation: .cancel)
//    }
    
}

class SplitViewDelegate: NSObject, UISplitViewControllerDelegate {
    
    
    weak var savedGraphsViewController: DatasetsViewController?
    weak var  graphDetailsViewController: GraphDetailsViewController?
    
    
//    func splitViewController(_ svc: UISplitViewController,
//                             willShow vc: UIViewController,
//                             invalidating barButtonItem: UIBarButtonItem)
//    {
////        if let detailView = svc.viewControllers.first as? UINavigationController {
////            svc.navigationItem.backBarButtonItem = nil
////            detailView.topViewController?.navigationItem.leftBarButtonItem = nil
////        }
//        print(vc)
//    }
    
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
        
//
//        guard let navigationController = primaryViewController as? UINavigationController,
//            let controller = navigationController.topViewController as? DatasetsViewController
//        else {
//            return true
//        }
//
//        return false
    }
//    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
//
//        print(displayMode)
//    }
}
//extension UISplitViewController {
//    func toggleMasterView() {
//        let barButtonItem = self.displayModeButtonItem
//        UIApplication.shared.sendAction(barButtonItem.action!, to: barButtonItem.target, from: nil, for: nil)
//    }
//}
