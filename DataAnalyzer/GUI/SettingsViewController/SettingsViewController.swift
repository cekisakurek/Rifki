//
//  SettingsViewController.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 11.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    let items = [NSLocalizedString("Analysis Tab", comment: ""),NSLocalizedString("Heatmap Tab", comment: "")]
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.white
        
        self.title = NSLocalizedString("Settings", comment: "")
        
        let closeItem = UIBarButtonItem(title: NSLocalizedString("Close", comment: ""), style: .plain, target: self, action: #selector(dismissController))
        self.navigationItem.rightBarButtonItem = closeItem
        
        self.tableView.estimatedRowHeight = 100.0;
        self.tableView.register(NameInputTableViewCell.self, forCellReuseIdentifier: "NameCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.register(StaticTextTableViewCell.self, forCellReuseIdentifier: "StaticValueCell")
    }
    
    @objc func dismissController() {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SettingsChanged"), object: nil)
        
        self.dismiss(animated: true) {
            
        }
    }
        
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = item
        return cell
        
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let pickerViewController = AnalysisTabSettingsViewController()
            self.navigationController?.pushViewController(pickerViewController, animated: true)
        }
        else if indexPath.row == 1 {
            let pickerViewController = HeatmapSettingsViewController()
            self.navigationController?.pushViewController(pickerViewController, animated: true)
        }
    }
}


class ColorSelectionTableViewCell: UITableViewCell {
    
    private var staticTextLabel: UILabel!
    private var colorView: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        self.accessoryType = .disclosureIndicator
        staticTextLabel = UILabel(frame: .zero)
        staticTextLabel.translatesAutoresizingMaskIntoConstraints = false
//        staticTextLabel.layer.borderColor = UIColor.lightGray.cgColor
//        staticTextLabel.layer.borderWidth = 1.0
        
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

protocol ObjectBooleanInputProtocol: class {
    
    func valueInputFieldChanged(toValue: Bool)
}

class BoolValueInputTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    private var staticTextLabel: UILabel!
    
    private var valueSwitchContainer: UIView!
    private var valueSwitch: UISwitch!
    
    weak var valueSwitchChangeDelegate: ObjectBooleanInputProtocol?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
        staticTextLabel = UILabel(frame: .zero)
        staticTextLabel.translatesAutoresizingMaskIntoConstraints = false
//        staticTextLabel.layer.borderColor = UIColor.lightGray.cgColor
//        staticTextLabel.layer.borderWidth = 1.0
        
        
        valueSwitchContainer = UIView(frame: .zero)
        valueSwitchContainer.translatesAutoresizingMaskIntoConstraints = false
//        valueSwitchContainer.layer.borderColor = UIColor.lightGray.cgColor
//        valueSwitchContainer.layer.borderWidth = 1.0
        
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

protocol ObjectValueInputProtocol: class {
    
    func valueInputFieldChanged(toValue: Double?)
}

class DoubleValueInputTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    private var staticTextLabel: UILabel!
    private var valueField: UITextField!
    
    weak var valueFieldChangeDelegate: ObjectValueInputProtocol?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        self.accessoryType = .disclosureIndicator
        staticTextLabel = UILabel(frame: .zero)
        staticTextLabel.translatesAutoresizingMaskIntoConstraints = false
//        staticTextLabel.layer.borderColor = UIColor.lightGray.cgColor
//        staticTextLabel.layer.borderWidth = 1.0
        
        valueField = UITextField(frame: .zero)
//        valueField.backgroundColor = UIColor.lightGray
        valueField.textAlignment = .right
        valueField.translatesAutoresizingMaskIntoConstraints = false
        valueField.keyboardType = .decimalPad
        valueField.delegate = self
        valueField.font = UIFont.boldSystemFont(ofSize: 16)
        valueField.addTarget(self, action: #selector(valueDidChange), for: .editingChanged)
        valueField.borderStyle = .roundedRect
        
//        valueField.layer.borderColor = UIColor.lightGray.cgColor
//        valueField.layer.borderWidth = 1.0
        
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



















extension String {
    func isValidDouble(maxDecimalPlaces: Int) -> Bool {
        // Use NumberFormatter to check if we can turn the string into a number
        // and to get the locale specific decimal separator.
        let formatter = NumberFormatter()
        
        formatter.allowsFloats = true // Default is true, be explicit anyways
        let decimalSeparator = "."// formatter.decimalSeparator ?? "."  // Gets the locale specific decimal separator. If for some reason there is none we assume "." is used as separator.
        formatter.decimalSeparator = decimalSeparator
        // Check if we can create a valid number. (The formatter creates a NSNumber, but
        // every NSNumber is a valid double, so we're good!)
        if formatter.number(from: self) != nil {
            // Split our string at the decimal separator
            let split = self.components(separatedBy: decimalSeparator)
            
            // Depending on whether there was a decimalSeparator we may have one
            // or two parts now. If it is two then the second part is the one after
            // the separator, aka the digits we care about.
            // If there was no separator then the user hasn't entered a decimal
            // number yet and we treat the string as empty, succeeding the check
            let digits = split.count == 2 ? split.last ?? "" : ""
            
            // Finally check if we're <= the allowed digits
            return digits.count <= maxDecimalPlaces    // TODO: Swift 4.0 replace with digits.count, YAY!
        }
        
        return false // couldn't turn string into a valid number
    }
}
