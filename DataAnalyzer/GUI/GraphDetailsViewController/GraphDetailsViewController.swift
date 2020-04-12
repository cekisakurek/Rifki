//
//  GraphDetailsViewController.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 31.03.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit
import CoreData
import CSV

class GraphDetailsViewController: UIViewController, UIPageViewControllerDelegate {
    
    private var selectDatasetView: SelectDatasetView!
    
    var pageViewController: UIPageViewController?
    
    var dataset: GraphRawData? {
        didSet {
            
            if dataset == nil {
                showSelectDatasetView()
            }
            else {
                hideSelectDatasetView()
            }
            
            self.rawDataViewController.dataset = dataset
            self.rowAnalysisViewController.dataset = dataset
            self.heatmapViewController.dataset = dataset
            self.playgroundViewController.dataset = dataset
        }
    }
      
    var currentIndex: Int = 0
    
    var pageController: UIPageViewController!
    
    let rawDataViewController = RawDataViewController()
    let rowAnalysisViewController = RowAnalysisViewController()
    let heatmapViewController = HeatMapViewController()
    let playgroundViewController = PlaygroundViewController.defaultPlaygroundViewController()
    
    override func loadView() {
        super.loadView()
        
        self.title = NSLocalizedString("Details", comment: "")
        
        self.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
        self.navigationItem.leftItemsSupplementBackButton = true
        
        let settingsItem = UIBarButtonItem(title: NSLocalizedString("Settings", comment: ""), style: .plain, target: self, action: #selector(showSettings))
        self.navigationItem.rightBarButtonItem = settingsItem
        
        let items = [
            NSLocalizedString("Raw Data", comment: ""),
            NSLocalizedString("Analysis", comment: ""),
            NSLocalizedString("Heatmap", comment: ""),
            NSLocalizedString("Playground", comment: "")
        ]
        
        let segmentControl = UISegmentedControl(items: items)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(changeViewController), for: .valueChanged)

        self.navigationItem.titleView = segmentControl
        
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
        
        pageController.isDoubleSided = true
//        pageController.dataSource = self
        pageController.delegate = self
        
        let contentControllers = [rawDataViewController]
        
        pageController.setViewControllers(contentControllers, direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        
        pageViewController = pageController
        
        self.addChild(pageViewController!)
        self.view.insertSubview(pageViewController!.view, at: 0)
        pageViewController!.didMove(toParent: self)
        
        selectDatasetView = SelectDatasetView(frame: .zero)
        selectDatasetView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(selectDatasetView)

        let defaultConstraints = [
            self.selectDatasetView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.selectDatasetView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.selectDatasetView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.selectDatasetView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(defaultConstraints)
    }
    
    @objc func changeViewController(sender: UISegmentedControl) {
        
        var direction: UIPageViewController.NavigationDirection = UIPageViewController.NavigationDirection.reverse
        
        if currentIndex < sender.selectedSegmentIndex {
            direction = UIPageViewController.NavigationDirection.forward
        }
        
        switch sender.selectedSegmentIndex {
            case 0:
                pageController.setViewControllers([rawDataViewController], direction: direction, animated: true, completion: nil)
            case 1:
                pageController.setViewControllers([rowAnalysisViewController], direction: direction, animated: true, completion: nil)
            case 2:
                pageController.setViewControllers([heatmapViewController
                ], direction: direction, animated: true, completion: nil)
            case 3:
                pageController.setViewControllers([playgroundViewController], direction: direction, animated: true, completion: nil)
            default:
                break
        }
        
        currentIndex = sender.selectedSegmentIndex
    }
    
    
    // MARK: - Show/Hide functions
    
    func loadingDataset() {
        showSelectDatasetView()
        selectDatasetView.startAnimating(with: NSLocalizedString("Dataset is loading", comment: ""))
    }
    
    func datasetLoaded() {
        hideSelectDatasetView()
        selectDatasetView.stopAnimating()
    }
    
    func hideSelectDatasetView() {
        selectDatasetView.isHidden = true
    }
    
    func showSelectDatasetView() {
        selectDatasetView.isHidden = false
    }
 
    @objc func showSettings() {
        let viewController = SettingsViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        self.present(navigationController, animated: true) {
            
        }
    }

}
