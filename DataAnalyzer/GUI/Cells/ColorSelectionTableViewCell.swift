//
//  ColorSelectionTableViewCell.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 29.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit

class ColorSelectionTableViewCell: UITableViewCell {
    
    private var staticTextLabel: UILabel!
    private var colorView: UIView!
    
    static let identifier = "ColorCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        self.accessoryType = .disclosureIndicator
        staticTextLabel = UILabel(frame: .zero)
        staticTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        colorView = UIView(frame: .zero)
        colorView.layer.cornerRadius = 4.0
        colorView.layer.borderColor = UIColor(white: 215.0/255.0, alpha: 1.0).cgColor
        colorView.layer.borderWidth = 1.0
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(staticTextLabel)
        self.contentView.addSubview(colorView)
        
        let margin = CGFloat(8.0)
        
        NSLayoutConstraint.activate([
            staticTextLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: margin),
            staticTextLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: margin),
            staticTextLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -margin),
            staticTextLabel.trailingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: -margin),
            
            colorView.topAnchor.constraint(equalTo: staticTextLabel.topAnchor),
            colorView.bottomAnchor.constraint(equalTo: staticTextLabel.bottomAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 80.0),
            colorView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -margin),
            staticTextLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50.0)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValueName(_ name: String?, color: UIColor?) {
        staticTextLabel.text = name
        colorView.backgroundColor = color
    }
}
