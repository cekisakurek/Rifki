//
//  HeatmapCalculationIndicatorView.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 29.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//
// Code review done 15. Aug. 2021

import UIKit

class HeatmapCalculationIndicatorView: UIView {
    
    private var activityIndicator: UIActivityIndicatorView
    private var activityIndicatorLabel: UILabel
    
    override init(frame: CGRect) {
        
        self.activityIndicator = UIActivityIndicatorView(style: .large)
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.color = UIColor.black
        
        self.activityIndicatorLabel = UILabel(frame: .zero)
        self.activityIndicatorLabel.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicatorLabel.textColor = UIColor.black
        self.activityIndicatorLabel.textAlignment = .center
        
        super.init(frame: frame)
        
        self.addSubview(self.activityIndicator)
        self.addSubview(self.activityIndicatorLabel)
        
        NSLayoutConstraint.activate([
            self.activityIndicator.topAnchor.constraint(equalTo: self.topAnchor),
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.activityIndicator.bottomAnchor.constraint(equalTo: self.activityIndicatorLabel.topAnchor, constant: -8.0),
            
            self.activityIndicatorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.activityIndicatorLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.activityIndicatorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func setMessage(_ message: String?) {
        self.activityIndicatorLabel.text = message
    }
    
    class func showFrom(view: UIView, message: String) -> HeatmapCalculationIndicatorView {
        let activityView = HeatmapCalculationIndicatorView(frame: .zero)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.setMessage(message)
        
        view.addSubview(activityView)
        NSLayoutConstraint.activate([
            activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        activityView.activityIndicator.startAnimating()
        return activityView
    }
        
    func hide() {
        self.activityIndicator.stopAnimating()
        self.removeFromSuperview()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(frame: .zero)
    }
}
