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

class GridCollectionViewLayout: UICollectionViewFlowLayout {

    var columnCount = 0
    var rowCount = 0
    
    // MARK: - Collection view flow layout methods
    override var collectionViewContentSize: CGSize {
        return CGSize(width: CGFloat(columnCount) * self.itemSize.width, height: CGFloat(rowCount) * self.itemSize.height)
    }

 

//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//
//        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//
//        var xOffset: CGFloat = CGFloat(indexPath.item * 100)
//        var yOffset: CGFloat = CGFloat(indexPath.section * 100)
//
//        attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height)
//        return attributes
//    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()

        if rowCount == 0 {
            return layoutAttributes
        }
        
        let startY = max(Int(ceil((rect.minY)/self.itemSize.height)),0)
        
        
        // calculate next screen
        let endY = min(startY + Int(ceil(rect.height / self.itemSize.height)), rowCount)
        
        
        for row in startY..<endY {
            var xOffset: CGFloat = 100
            let yOffset: CGFloat = CGFloat(row) * self.itemSize.height
            for col in 0..<columnCount {
                
                let indexPath = IndexPath(row: row, column: col)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                if col == 0 {
                    var frame = attributes.frame
                    frame.origin.y = yOffset
                    frame.origin.x += collectionView!.contentOffset.x
                    frame.size = CGSize(width: 100.0, height: 50.0)
                    attributes.frame = frame
                    attributes.zIndex = 99
                    layoutAttributes.append(attributes)
                }
                else {
                    
                    attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height)
                    layoutAttributes.append(attributes)
                    xOffset += itemSize.width
                }
            }
        }
        
        // header
        for col in 0..<columnCount {
            let headerIndexPath = IndexPath(row: 0, column: col)
            let headerAttributes = UICollectionViewLayoutAttributes(forCellWith: headerIndexPath)
            var frame = headerAttributes.frame
            frame.origin.y += collectionView!.contentOffset.y
            frame.origin.x = (CGFloat(col) * 100.0)
            frame.size = CGSize(width: 100.0, height: 50.0)
            headerAttributes.frame = frame
            headerAttributes.zIndex = 100
            layoutAttributes.append(headerAttributes)
        }
        
        
        // 0-0 is always there
        
        let headerIndexPath = IndexPath(row: 0, column: 0)
        let headerAttributes = UICollectionViewLayoutAttributes(forCellWith: headerIndexPath)
        var frame = headerAttributes.frame
        frame.origin.y += collectionView!.contentOffset.y
        frame.origin.x += collectionView!.contentOffset.x
        frame.size = CGSize(width: 100.0, height: 50.0)
        headerAttributes.frame = frame
        headerAttributes.zIndex = 105
        layoutAttributes.append(headerAttributes)
        
        
        
        return layoutAttributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

// MARK: - IndexPath
private extension IndexPath {
    init(row: Int, column: Int) {
        self = IndexPath(item: column, section: row)
    }
}

// MARK: - ZOrder
private enum ZOrder {
    static let commonItem = 0
    static let stickyItem = 1
    static let staticStickyItem = 2
}


class GraphDetailsViewController: UIViewController, UIPageViewControllerDelegate {
    
    var pageViewController: UIPageViewController?
    
    var dataset: GraphRawData? {
        didSet {
            self.rawDataViewController.dataset = dataset
            self.rowAnalysisViewController.dataset = dataset
            self.heatmapViewController.dataset = dataset
        }
    }
  
    
    
//    var graph: GraphData? {
//        didSet {
//
//            let fileURL = graph?.fileURL()!
//            let rawData = GraphRawData(url: fileURL!)
//
////            self.heatmapViewController.graphRawData = rawData
//
//
//            self.rawDataViewController.graphRawData = rawData
////            self.rowAnalysisViewController.graphRawData = rawData
////            self.heatmapViewController.graphRawData = rawData
////            self.editViewController.graph = self.graph
////            self.plotViewController.graph = self.graph
////            self.descriptionViewController.graphItems = self.graph!.rawItems()
//        }
//    }
    
    
    
    var currentIndex: Int = 0
    
    var pageController: UIPageViewController!
    
    
//    let configurationViewController = DatasetConfigurationViewController()
    
    let rawDataViewController = RawDataViewController()
    let rowAnalysisViewController = RowAnalysisViewController()
    
    let heatmapViewController = HeatMapViewController()
//    let descriptionViewController = DatasetDescriptionViewController()
//    let plotViewController = PlotViewController()
    
    override func loadView() {
        super.loadView()
        
        self.title = NSLocalizedString("Details", comment: "")
        
        self.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
        self.navigationItem.leftItemsSupplementBackButton = true
        
        let items = [
            NSLocalizedString("Raw Data", comment: ""),
            NSLocalizedString("Analysis", comment: ""),
            NSLocalizedString("Heatmap", comment: ""),
//            NSLocalizedString("Description", comment: ""),
//            NSLocalizedString("Plot", comment: "")
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
        

        segmentControl.selectedSegmentIndex = 0
        
        changeViewController(sender: segmentControl)
        
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
            pageController.setViewControllers([heatmapViewController], direction: direction, animated: true, completion: nil)
        default:
            break
        }
        
        currentIndex = sender.selectedSegmentIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
//        pendingIndex = (pendingViewControllers.first as! ContentView).itemIndex
    }
    
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//
//        if viewController == plotViewController {
//            return rawDataViewController
//        }
//
//        return nil
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//
//        if viewController == rawDataViewController {
//            return plotViewController
//        }
//        return nil
//    }
    
    
    
    
    

}
