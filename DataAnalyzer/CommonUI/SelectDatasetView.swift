//
//  SelectDatasetView.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 11.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit

class SelectDatasetView: UIView {
    
    private var containerView: UIView!
    
    private var activityIndicator: UIActivityIndicatorView!
    private var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        containerView = UIView(frame: .zero)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(containerView)
        
        
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("Please select a dataset", comment: "")
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.textColor = UIColor.white
        label.textAlignment = .center
        containerView.addSubview(label)
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = UIColor.white
        containerView.addSubview(activityIndicator)
        
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: label.topAnchor),
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating(with message: String) {
        activityIndicator.startAnimating()
        label.text = message
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
        label.text = NSLocalizedString("Please select a dataset", comment: "")
    }
    
}
