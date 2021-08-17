//
//  SelectDatasetView.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 11.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

// Code review done 15. Aug. 2021

import UIKit

class SelectDatasetView: UIView {
    
    private var containerView: UIView
    private var activityIndicator: UIActivityIndicatorView
    private var label: UILabel
    
    override init(frame: CGRect) {
        
        self.containerView = UIView(frame: .zero)
        self.containerView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.label = UILabel(frame: .zero)
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.text = NSLocalizedString("No dataset", comment: "")
        self.label.font = UIFont.systemFont(ofSize: 20.0)
        self.label.textColor = UIColor.black
        self.label.textAlignment = .center
        
        self.activityIndicator = UIActivityIndicatorView(style: .large)
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.color = UIColor.black
        
        super.init(frame: frame)
        
        self.addSubview(containerView)
        self.containerView.addSubview(self.label)
        self.containerView.addSubview(self.activityIndicator)
        
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.topAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.label.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor),
            self.label.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.activityIndicator.bottomAnchor.constraint(equalTo: self.label.topAnchor, constant: -8.0)
        ])
    }
    
    func startAnimating(with message: String) {
        self.activityIndicator.startAnimating()
        self.label.text = message
    }
    
    func stopAnimating() {
        self.activityIndicator.stopAnimating()
        self.label.text = NSLocalizedString("No dataset", comment: "")
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(frame: .zero)
    }
}
