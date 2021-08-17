//
//  StaticTextTableViewCell.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 29.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit

class StaticTextTableViewCell: UITableViewCell {
    
    private var staticTextLabel: UILabel!
    private var staticValueLabel: UILabel!
    
    static let identifier = "StaticValueCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        self.accessoryType = .disclosureIndicator
        staticTextLabel = UILabel(frame: .zero)
        staticTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        staticValueLabel = UILabel(frame: .zero)
        staticValueLabel.translatesAutoresizingMaskIntoConstraints = false
        staticValueLabel.adjustsFontSizeToFitWidth = true
        staticValueLabel.minimumScaleFactor = 0.2
        
        self.contentView.addSubview(staticTextLabel)
        self.contentView.addSubview(staticValueLabel)
        
        let margin = CGFloat(8.0)
        
        NSLayoutConstraint.activate([
            staticTextLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: margin),
            staticTextLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: margin),
            staticTextLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -margin),
            staticTextLabel.trailingAnchor.constraint(equalTo: staticValueLabel.leadingAnchor, constant: -margin),
            
            staticValueLabel.topAnchor.constraint(equalTo: staticTextLabel.topAnchor),
            staticValueLabel.bottomAnchor.constraint(equalTo: staticTextLabel.bottomAnchor),
            staticValueLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -margin),
            staticTextLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50.0)
            
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValueName(_ name: String?, value: String?) {
        staticTextLabel.text = name
        staticValueLabel.text = value
    }
}
