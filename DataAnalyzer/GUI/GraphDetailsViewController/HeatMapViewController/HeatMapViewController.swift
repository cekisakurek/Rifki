//
//  HeatMapViewController.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 05.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit
import SigmaSwiftStatistics
import CoreData

class HeatMapViewController: UIViewController {
    
    var scrollView = UIScrollView()
    var heatMapContainer = HeatMapContainerView()
    
    var calculationQueue = CalculationsOperationQueue()
    
    private var heatmapTheme = HeatmapTheme()
    
    private var result: HeatMapResult?
    
    var dataset: GraphRawData? {
        didSet {
            if let dataset = dataset, self.isViewLoaded {
                
                self.heatMapContainer.isHidden = false
                let activityIndicatorView = HeatmapCalculationIndicatorView.showFrom(view: self.view, message: NSLocalizedString("Generating Heatmap", comment: ""))
                self.heatMapContainer.setLabels(nil, corrolation: nil)
                self.calculationQueue.calculateHeatMap(dataset) {
                    (result, error) in
                    
                    self.result = result
                    self.drawHeatmap()
                    activityIndicatorView.hide()
                }
            }
        }
    }
    
    @objc func updateTheme() {
        do {
            let context = CoreDataController.shared.writeContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
            let settings = try context.fetch(fetchRequest) as! [Settings]
            if let settingsObject = settings.first {
                heatmapTheme.maxColor = settingsObject.heatmapMaxColor as! UIColor
                heatmapTheme.minColor = settingsObject.heatmapMinColor as! UIColor
                heatmapTheme.valuesVisible = settingsObject.heatmapValuesVisible
                heatMapContainer.setColors(max: heatmapTheme.maxColor, min: heatmapTheme.minColor)
                heatMapContainer.setValuesVisible(heatmapTheme.valuesVisible)
                drawHeatmap()
            }
        }
        catch {
            ErrorAlertView.showError(with: String(describing: error), from: self)
        }
    }
    
    override func loadView() {
        super.loadView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTheme), name: NSNotification.Name(rawValue: "SettingsChanged"), object: nil)
        
        updateTheme()
        
        self.view.backgroundColor = UIColor.white
        
        heatMapContainer.frame = self.view.bounds
        heatMapContainer.layer.borderColor = UIColor.lightGray.cgColor
        heatMapContainer.layer.borderWidth = 1.0
        heatMapContainer.isHidden = true
        heatMapContainer.setColors(max: heatmapTheme.maxColor, min: heatmapTheme.minColor)
        heatMapContainer.setValuesVisible(heatmapTheme.valuesVisible)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 2.0
        
        scrollView.addSubview(heatMapContainer)
        self.view.addSubview(scrollView)
        
        let defaultConstraints = [
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ]

        NSLayoutConstraint.activate(defaultConstraints)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // if needs scroll
        if heatMapContainer.bounds.size.width > self.view.bounds.size.width  ||
            heatMapContainer.bounds.size.height > self.view.bounds.size.height {

        }
        else {
            heatMapContainer.frame = CGRect(x: (self.view.bounds.size.width - heatMapContainer.bounds.size.width) / 2.0,
                                            y: 0.0,
                                            width: heatMapContainer.bounds.size.width,
                                            height: heatMapContainer.bounds.size.height)
            
        }
        scrollView.contentSize = heatMapContainer.bounds.size
        
        let scale = scrollView.frame.size.width / scrollView.contentSize.width
        scrollView.zoomScale = scale
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let dataset = dataset {
            let activityIndicatorView = HeatmapCalculationIndicatorView.showFrom(view: self.view, message: NSLocalizedString("Generating Heatmap", comment: ""))
            self.calculationQueue.calculateHeatMap(dataset) {
                
                [weak self] (result, error) in

                guard let self = self else {
                    return
                }
                
                self.result = result
                self.heatMapContainer.isHidden = false
                self.drawHeatmap()
                activityIndicatorView.hide()
            }
        }
    }
    
    func drawHeatmap() {
        self.scrollView.delegate = self
        self.heatMapContainer.setLabels(result?.labels, corrolation: result?.matrix)
        self.view.setNeedsLayout()
    }
}

extension HeatMapViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return heatMapContainer
    }
       
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var top: CGFloat = 0.0
        var left: CGFloat = 0.0
           
        if scrollView.contentSize.width < self.view.bounds.size.width {
            left = (self.view.bounds.size.width - scrollView.contentSize.width) * 0.5
        }
        if scrollView.contentSize.height < self.view.bounds.size.height {
            top = (self.view.bounds.size.height - scrollView.contentSize.height) * 0.5
        }
        scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
    }
}
