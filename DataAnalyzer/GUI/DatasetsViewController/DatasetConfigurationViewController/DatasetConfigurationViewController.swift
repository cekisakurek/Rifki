//
//  DatasetConfigurationViewController.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 08.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit

struct Delimiter {
    let value: String
    let name: String
}

let comma = Delimiter(value: ",", name: "comma ','")
let semicolon = Delimiter(value: ";", name: "semicolon ';'")
let tab = Delimiter(value: "\t", name: "tab ' \\t' ")
let colon = Delimiter(value: ":", name: "colon ' : '")
let pipe = Delimiter(value: "|", name: "pipe '|'")

protocol DelimiterSelectionDelegate: class {
    
    func delimiterSelected(delimiter: Delimiter)
}


class DelimiterSelectionTableView: UITableViewController {
    
    private var delimiters:[Delimiter]!
    
    weak var selectionDelegate: DelimiterSelectionDelegate?
    
    override func loadView() {
        super.loadView()
        
        
        
        delimiters = [comma, semicolon, tab, colon, pipe]
    
        
        self.tableView.estimatedRowHeight = 100.0;
        self.tableView.register(DatasetNameTableViewCell.self, forCellReuseIdentifier: "NameCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.register(DatasetStaticTextTableViewCell.self, forCellReuseIdentifier: "StaticValueCell")
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return NSLocalizedString("Columns", comment: "")
        }
        return nil
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return delimiters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let delimiter = delimiters[indexPath.row]
        cell.textLabel?.text = delimiter.name
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let delegate = selectionDelegate {
            let delimiter = delimiters[indexPath.row]
            delegate.delimiterSelected(delimiter: delimiter)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}



class DatasetConfigurationViewController: UITableViewController, DelimiterSelectionDelegate, DatasetNamingProtocol {
    
    var dataset: GraphData!
    
    var rawData: GraphRawData!
    
    override func loadView() {
        super.loadView()
        
        
        if let name = dataset.name {
            self.title = name
        }

        self.tableView.estimatedRowHeight = 100.0;
        self.tableView.register(DatasetNameTableViewCell.self, forCellReuseIdentifier: "NameCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.register(DatasetStaticTextTableViewCell.self, forCellReuseIdentifier: "StaticValueCell")
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return NSLocalizedString("Columns", comment: "")
        }
        return nil
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            case 0:
                return 3
            default:
                return rawData.headers!.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as! DatasetNameTableViewCell
                    cell.setName(dataset.name)
                    cell.nameFieldChangeDelegate = self
                    return cell
                    
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "StaticValueCell", for: indexPath) as! DatasetStaticTextTableViewCell
                    cell.accessoryType = .disclosureIndicator
                    let nameString = NSLocalizedString("Delimiter", comment: "") + " :"
                    let valueString = " '\(dataset.delimiter ?? "")' "
                    cell.setValueName(nameString , value: valueString)
                    
                    return cell
                case 2:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "StaticValueCell", for: indexPath) as! DatasetStaticTextTableViewCell
                    cell.setValueName( NSLocalizedString("File Id", comment: ""), value: dataset.localURL)
                    
                    return cell
                    
                default:
                    break
            }
            case 1:
                let columnName = rawData.headers![indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                cell.textLabel?.text = columnName
                return cell
            default:
            break
        }
        
        
        

        return tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 1 {
            let viewController = DelimiterSelectionTableView()
            viewController.selectionDelegate = self
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    func delimiterSelected(delimiter: Delimiter) {
        dataset.delimiter = delimiter.value
        tableView.reloadData()
    }
    
    func datasetNameFieldChanged(toString: String?) {
        dataset.name = toString
    }
}


protocol DatasetNamingProtocol: class {
    
    func datasetNameFieldChanged(toString: String?)
}


class DatasetNameTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    private var nameField: UITextField!
    
    weak var nameFieldChangeDelegate: DatasetNamingProtocol?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        
        nameField = UITextField(frame: .zero)
        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.placeholder = NSLocalizedString("Name:", comment: "")
        nameField.font = UIFont.boldSystemFont(ofSize: 16)
//        nameField.delegate = self
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
    
    @objc func nameDidChange() {
        if let delegate = nameFieldChangeDelegate {
            delegate.datasetNameFieldChanged(toString: nameField.text)
        }
    }
    
}

class DatasetStaticTextTableViewCell: UITableViewCell {
    
    private var staticTextLabel: UILabel!
    private var staticValueLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        
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
