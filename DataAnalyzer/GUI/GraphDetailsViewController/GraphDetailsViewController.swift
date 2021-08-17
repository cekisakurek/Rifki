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
    
    var pageViewController: DAPageViewController!
    
    var dataset: GraphRawData? {
        didSet {
            
            if dataset == nil {
                self.showSelectDatasetView()
            }
            else {
                self.hideSelectDatasetView()
            }
            
            self.rawDataViewController.dataset = dataset
            self.rowAnalysisViewController.dataset = dataset
            self.heatmapViewController.dataset = dataset
            self.playgroundViewController.dataset = dataset
        }
    }
      
    var currentIndex: Int = 0
    
    let rawDataViewController = RawDataViewController()
    let rowAnalysisViewController = RowAnalysisViewController()
    let heatmapViewController = HeatMapViewController()
    let playgroundViewController = PlaygroundViewController.defaultPlaygroundViewController()
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.white
        
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
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)

        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)

        self.navigationItem.titleView = segmentControl

        self.pageViewController = DAPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
        self.pageViewController.view.backgroundColor = UIColor.white
        self.pageViewController.isDoubleSided = true
        self.pageViewController.delegate = self

        let contentControllers = [self.rawDataViewController]

        self.pageViewController.setViewControllers(contentControllers, direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)


        self.addChild(self.pageViewController!)
        self.view.insertSubview(self.pageViewController!.view, at: 0)
        self.pageViewController.didMove(toParent: self)

        self.selectDatasetView = SelectDatasetView(frame: .zero)
        self.selectDatasetView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.selectDatasetView)

        NSLayoutConstraint.activate([
            self.selectDatasetView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.selectDatasetView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.selectDatasetView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.selectDatasetView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.pageViewController.view.frame = self.view.frame
    }
    
    @objc func changeViewController(sender: UISegmentedControl) {
        
        var direction: UIPageViewController.NavigationDirection = UIPageViewController.NavigationDirection.reverse
        
        if self.currentIndex < sender.selectedSegmentIndex {
            direction = UIPageViewController.NavigationDirection.forward
        }
        
        switch sender.selectedSegmentIndex {
            case 0:
                self.pageViewController.setViewControllers([rawDataViewController], direction: direction, animated: true, completion: nil)
            case 1:
                self.pageViewController.setViewControllers([rowAnalysisViewController], direction: direction, animated: true, completion: nil)
            case 2:
                self.pageViewController.setViewControllers([heatmapViewController
                ], direction: direction, animated: true, completion: nil)
            case 3:
                self.pageViewController.setViewControllers([playgroundViewController], direction: direction, animated: true, completion: nil)
            default:
                break
        }
        
        self.currentIndex = sender.selectedSegmentIndex
    }
    
    
    // MARK: - Show/Hide functions
    
    func loadingDataset() {
        self.showSelectDatasetView()
        self.selectDatasetView.startAnimating(with: NSLocalizedString("Dataset is loading", comment: ""))
    }
    
    func datasetLoaded() {
        self.hideSelectDatasetView()
        self.selectDatasetView.stopAnimating()
    }
    
    func hideSelectDatasetView() {
        self.selectDatasetView.isHidden = true
    }
    
    func showSelectDatasetView() {
        self.selectDatasetView.isHidden = false
    }
 
    @objc func showSettings() {
        let viewController = SettingsViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true)
    }
}


class DAPageViewController: UIPageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
}
