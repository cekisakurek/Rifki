//
//  NameInputTableViewCell.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 29.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit

protocol ObjectNamingProtocol: class {    
    func objectNameFieldChanged(toString: String?)
}

class NameInputTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    private var nameField: UITextField!
    
    static let identifier = "NameCell"
    
    weak var nameFieldChangeDelegate: ObjectNamingProtocol?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        self.selectionStyle = .none
        nameField = UITextField(frame: .zero)
        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.placeholder = NSLocalizedString("Name:", comment: "")
        nameField.font = UIFont.systemFont(ofSize: 16)
        nameField.addTarget(self, action: #selector(nameDidChange), for: .editingChanged)

        self.contentView.addSubview(nameField)
        
        let margin = CGFloat(8.0)
        
        NSLayoutConstraint.activate([
            nameField.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: margin),
            nameField.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: margin),
            nameField.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -margin),
            nameField.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -margin),
            nameField.heightAnchor.constraint(greaterThanOrEqualToConstant: 50.0)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setName(_ name: String?) {
        nameField.text = name
    }
    
    func setPlaceholder(_ placeholder: String?) {
        nameField.placeholder = placeholder
    }
    
    @objc func nameDidChange() {
        if let delegate = nameFieldChangeDelegate {
            delegate.objectNameFieldChanged(toString: nameField.text)
        }
    }
}
