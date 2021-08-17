//
//  ImportDatasetSettingsViewController.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 28.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit

class ImportLocalDatasetSettingsViewController: UITableViewController, DelimiterSelectionDelegate, ObjectNamingProtocol, ObjectBooleanInputProtocol {
    
    weak var controller: AddDataSetController?
    var fileURL: URL?
    var currentDelimiter = comma
    var datasetName = NSLocalizedString("New Dataset", comment: "")
    var hasHeader = true
    
    // MARK: - View
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.white

        self.title = NSLocalizedString("Import", comment: "")

        self.tableView.estimatedRowHeight = 100.0;
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.register(NameInputTableViewCell.self, forCellReuseIdentifier: NameInputTableViewCell.identifier)
        
        self.tableView.register(StaticTextTableViewCell.self, forCellReuseIdentifier: StaticTextTableViewCell.identifier)
        self.tableView.register(BoolValueInputTableViewCell.self, forCellReuseIdentifier: BoolValueInputTableViewCell.identifier)
        
        let closeItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
        self.navigationItem.leftBarButtonItem = closeItem
        
        let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveGraph))
        self.navigationItem.rightBarButtonItem = saveItem
    }
    
    @objc func close() {
        self.dismiss(animated: true)
    }
    
    // MARK: - UITableViewDatasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: NameInputTableViewCell.identifier, for: indexPath) as! NameInputTableViewCell
                    cell.selectionStyle = .none
                    cell.nameFieldChangeDelegate = self
                    return cell
                    
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: StaticTextTableViewCell.identifier, for: indexPath) as! StaticTextTableViewCell
                    cell.accessoryType = .disclosureIndicator
                    cell.selectionStyle = .none
                    let nameString = NSLocalizedString("Delimiter", comment: "") + " :"
                    let valueString = "\(currentDelimiter.name)"
                    cell.setValueName(nameString , value: valueString)
                    
                    return cell
                    
                case 2:
                    let cell = tableView.dequeueReusableCell(withIdentifier: BoolValueInputTableViewCell.identifier, for: indexPath) as! BoolValueInputTableViewCell
                    cell.accessoryType = .none
                    if indexPath.row == 2 {
                        cell.valueSwitchChangeDelegate = self
                        let item = NSLocalizedString("Has Header", comment: "")
                        cell.setValueName(item, value: hasHeader)
                    }
                    return cell
                    
                default:
                    break
                }
            default:
                break
        }
        return tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 1 {
            let viewController = DelimiterSelectionTableViewController()
            viewController.selectionDelegate = self
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    func delimiterSelected(delimiter: Delimiter) {
        currentDelimiter = delimiter
        tableView.reloadData()
    }
    
    func objectNameFieldChanged(toString: String?) {
        if let newName = toString {
            datasetName = newName
        }
    }
    
    func valueInputFieldChanged(toValue: Bool) {
        hasHeader = toValue
    }
    
    @objc func saveGraph() {
        if let controller = controller {
            controller.importDataset(name: datasetName, url: self.fileURL!, delimiter: currentDelimiter.value, hasHeader: self.hasHeader)
        }
    }
}
