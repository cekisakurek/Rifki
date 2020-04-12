//
//  SettingsViewController.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 11.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    
    let items = [NSLocalizedString("Analysis Tab", comment: "")]
    
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
        
        return 1
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
        
        let pickerViewController = DistributionGraphSettingsViewController()
        self.navigationController?.pushViewController(pickerViewController, animated: true)
        
    }
}





class DistributionGraphSettingsViewController: UITableViewController, ColorPickerFromTableViewDelegate {
    
    func colorPicker(_ picker: ColorPickerViewController, didChange color: UIColor, forIndexPath: IndexPath) {
        distributionGraphChangeColor(color, index: forIndexPath.row)
        tableView.reloadData()
    }
    
    
    class DistributionGraphFrequencyLineWidthDelegate: ObjectValueInputProtocol {
        
        weak var settings: Settings?
        
        func valueInputFieldChanged(toValue: Double?) {
            if let settings = settings,
                let value = toValue {
                settings.dgFrequencyLineWidth = value
            }
        }
    }

    class DistributionGraphNormalLineWidthDelegate: ObjectValueInputProtocol {
        
        weak var settings: Settings?
        
        func valueInputFieldChanged(toValue: Double?) {
            if let settings = settings,
                let value = toValue {
                settings.dgNormalLineWidth = value
            }
        }
    }
    
    var frequencyLineDelegate = DistributionGraphFrequencyLineWidthDelegate()
    var normalLineDelegate = DistributionGraphNormalLineWidthDelegate()
    
    var settings: Settings?
    
    let distributionGraphItems = ["Background Color",
                                  "X-Axis Text Color",
                                  "Y-Axis Text Color",
                                  "Bar Color",
                                  "Frequency Line Color",
                                  "Frequency Line Width",
                                  "Normal Line Color",
                                  "Normal Line Width"]
    
    func distributionGraphValueForIndex(_ index: Int) -> Double? {
        switch index {
            case 5:
                return Double(settings!.dgFrequencyLineWidth)
            case 7:
                return Double(settings!.dgNormalLineWidth)
            default:
                return nil
        }
    }
    
    func distributionGraphChangeColor(_ color: UIColor, index: Int) {
        switch index {
            case 0:
                settings?.dgBackgroundColor = color
            case 1:
                settings?.dgXAxisTextColor = color
            case 2:
                settings?.dgYAxisTextColor = color
            case 3:
                settings?.dgBarColor = color
            case 4:
                settings?.dgFrequencyLineColor = color
            case 5:
                break
            case 6:
                settings?.dgNormalLineColor = color
            case 7:
                break
            default:
                break;
        }
    }
    
    func distributionGraphColorForIndex(_ index: Int) -> UIColor? {
        switch index {
            case 0:
                return settings?.dgBackgroundColor as? UIColor
            case 1:
                return settings?.dgXAxisTextColor as? UIColor
            case 2:
                return settings?.dgYAxisTextColor as? UIColor
            case 3:
                return settings?.dgBarColor as? UIColor
            case 4:
                return settings?.dgFrequencyLineColor as? UIColor
            case 5:
                return nil // frequency line width
            case 6:
                return settings?.dgNormalLineColor as? UIColor
            case 7:
                return nil // normal line width
            default:
                return nil
        }
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.white
        
        self.title = NSLocalizedString("Settings", comment: "")
        
        self.tableView.estimatedRowHeight = 100.0;
        self.tableView.register(NameInputTableViewCell.self, forCellReuseIdentifier: "NameCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.register(ColorSelectionTableViewCell.self, forCellReuseIdentifier: "ColorCell")
        self.tableView.register(DoubleValueInputTableViewCell.self, forCellReuseIdentifier: "DoubleValueCell")
        
        
        do {
            let context = CoreDataController.shared.managedObjectContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
            let settings = try context!.fetch(fetchRequest) as! [Settings]
            if let settingsObject = settings.first {
                self.settings = settingsObject
                self.frequencyLineDelegate.settings = self.settings
                self.normalLineDelegate.settings = self.settings
            }
        }
        catch {
            ErrorAlertView.showError(with: String(describing: error), from: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            try CoreDataController.shared.managedObjectContext.save()
            //            try self.settings?.managedObjectContext?.save()
        }
        catch {
            ErrorAlertView.showError(with: String(describing: error), from: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return NSLocalizedString("Distribution Graph", comment: "")
        }
        else if section == 1 {
            return NSLocalizedString("Probability Graph", comment: "")
        }
        return nil
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return distributionGraphItems.count
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let item = distributionGraphItems[indexPath.row]
                        
            if let color = distributionGraphColorForIndex(indexPath.row) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ColorCell", for: indexPath) as! ColorSelectionTableViewCell
                cell.accessoryType = .disclosureIndicator
                cell.setValueName(item, color: color)
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DoubleValueCell", for: indexPath) as! DoubleValueInputTableViewCell
                cell.accessoryType = .none
                if indexPath.row == 5 {
                    cell.valueFieldChangeDelegate = self.frequencyLineDelegate
                }
                if indexPath.row == 7 {
                    cell.valueFieldChangeDelegate = self.normalLineDelegate
                }
                
                
                let value = distributionGraphValueForIndex(indexPath.row)
                cell.setValueName(item, value: value)
                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.accessoryType = .none
        return cell
        
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let pickerViewController = ColorPickerViewController()
        pickerViewController.fromIndexPath = indexPath
        pickerViewController.tableColorDelegate = self
        self.navigationController?.pushViewController(pickerViewController, animated: true)
        
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
        
        colorView = UIView(frame: .zero)
        colorView.layer.cornerRadius = 4.0
        colorView.layer.borderColor = UIColor.lightGray.cgColor
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
            colorView.widthAnchor.constraint(equalToConstant: 50.0),
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
        
        valueField = UITextField(frame: .zero)
//        valueField.backgroundColor = UIColor.lightGray
        valueField.textAlignment = .right
        valueField.translatesAutoresizingMaskIntoConstraints = false
        valueField.keyboardType = .decimalPad
        valueField.delegate = self
        valueField.font = UIFont.boldSystemFont(ofSize: 16)
        valueField.addTarget(self, action: #selector(valueDidChange), for: .editingChanged)
        
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
            valueField.widthAnchor.constraint(equalToConstant: 100.0),
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
