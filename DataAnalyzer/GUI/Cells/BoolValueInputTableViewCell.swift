//
//  BoolValueInputTableViewCell.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 29.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit

protocol ObjectBooleanInputProtocol: class {
    func valueInputFieldChanged(toValue: Bool)
}

class BoolValueInputTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    private var staticTextLabel: UILabel!
    
    private var valueSwitchContainer: UIView!
    private var valueSwitch: UISwitch!
    
    static let identifier = "BoolValueCell"
    
    weak var valueSwitchChangeDelegate: ObjectBooleanInputProtocol?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
        staticTextLabel = UILabel(frame: .zero)
        staticTextLabel.translatesAutoresizingMaskIntoConstraints = false
                
        valueSwitchContainer = UIView(frame: .zero)
        valueSwitchContainer.translatesAutoresizingMaskIntoConstraints = false
        
        valueSwitch = UISwitch(frame: .zero)
        valueSwitch.translatesAutoresizingMaskIntoConstraints = false
        valueSwitch.addTarget(self, action: #selector(valueDidChange), for: .valueChanged)
        
        self.contentView.addSubview(staticTextLabel)
        self.contentView.addSubview(valueSwitchContainer)
        valueSwitchContainer.addSubview(valueSwitch)
        
        let margin = CGFloat(8.0)
        
        NSLayoutConstraint.activate([
            staticTextLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: margin),
            staticTextLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: margin),
            staticTextLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -margin),
            staticTextLabel.trailingAnchor.constraint(equalTo: valueSwitchContainer.leadingAnchor, constant: -margin),
            
            valueSwitchContainer.topAnchor.constraint(equalTo: staticTextLabel.topAnchor),
            valueSwitchContainer.bottomAnchor.constraint(equalTo: staticTextLabel.bottomAnchor),
            valueSwitchContainer.widthAnchor.constraint(equalToConstant: 80.0),
            valueSwitchContainer.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -margin - 30.0),
            staticTextLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50.0),
            
            valueSwitch.centerYAnchor.constraint(equalTo: valueSwitchContainer.centerYAnchor),
            valueSwitch.centerXAnchor.constraint(equalTo: valueSwitchContainer.centerXAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValueName(_ name: String, value: Bool) {
        staticTextLabel.text = name
        valueSwitch.isOn = value
    }
    @objc func valueDidChange() {
        if let delegate = valueSwitchChangeDelegate {
            delegate.valueInputFieldChanged(toValue: valueSwitch.isOn)
        }
    }
}
