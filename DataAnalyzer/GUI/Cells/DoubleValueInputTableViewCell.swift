//
//  DoubleValueInputTableViewCell.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 29.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit

protocol ObjectValueInputProtocol: class {
    func valueInputFieldChanged(toValue: Double?)
}

class DoubleValueInputTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    private var staticTextLabel: UILabel!
    private var valueField: UITextField!
    
    static let identifier = "DoubleValueCell"
    
    weak var valueFieldChangeDelegate: ObjectValueInputProtocol?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        self.accessoryType = .disclosureIndicator
        staticTextLabel = UILabel(frame: .zero)
        staticTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        valueField = UITextField(frame: .zero)
        valueField.textAlignment = .right
        valueField.translatesAutoresizingMaskIntoConstraints = false
        valueField.keyboardType = .decimalPad
        valueField.delegate = self
        valueField.font = UIFont.boldSystemFont(ofSize: 16)
        valueField.addTarget(self, action: #selector(valueDidChange), for: .editingChanged)
        valueField.borderStyle = .roundedRect
        
        self.contentView.addSubview(staticTextLabel)
        self.contentView.addSubview(valueField)
        
        let margin = CGFloat(8.0)
        
        NSLayoutConstraint.activate([
            staticTextLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: margin),
            staticTextLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: margin),
            staticTextLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -margin),
            staticTextLabel.trailingAnchor.constraint(equalTo: valueField.leadingAnchor, constant: -margin),
            
            valueField.topAnchor.constraint(equalTo: staticTextLabel.topAnchor),
            valueField.bottomAnchor.constraint(equalTo: staticTextLabel.bottomAnchor),
            valueField.widthAnchor.constraint(equalToConstant: 80.0),
            valueField.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -margin - 30.0),
            staticTextLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50.0)
            
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValueName(_ name: String, value: Double?) {
        staticTextLabel.text = name
        if let value = value {
            valueField.text = String(value)
        }
    }
    @objc func valueDidChange() {
        if let delegate = valueFieldChangeDelegate {
            let value = Double(valueField.text!) ?? 0.0
            delegate.valueInputFieldChanged(toValue: value)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // User pressed the delete-key to remove a character, this is always valid, return true to allow change
        if string.isEmpty { return true }
        
        // Build the full current string: TextField right now only contains the
        // previous valid value. Use provided info to build up the new version.
        // Can't just concat the two strings because the user might've moved the
        // cursor and delete something in the middle.
        let currentText = textField.text ?? ""
        let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // Use our string extensions to check if the string is a valid double and
        // only has the specified amount of decimal places.
        return replacementText.isValidDouble(maxDecimalPlaces: 2)
    }
    
}
