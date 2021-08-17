//
//  DatasetConfigurationViewController.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 08.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit

class DatasetConfigurationViewController: UITableViewController, DelimiterSelectionDelegate, ObjectNamingProtocol {
    
    var dataset: Dataset!
    var rawData: GraphRawData!
    
    // MARK: - View
    
    override func loadView() {
        super.loadView()
        
        if let name = dataset.name {
            self.title = name
        }

        self.tableView.estimatedRowHeight = 100.0;
        self.tableView.register(NameInputTableViewCell.self, forCellReuseIdentifier: "NameCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.register(StaticTextTableViewCell.self, forCellReuseIdentifier: "StaticValueCell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let dataset = dataset {
            
            do {
                try dataset.managedObjectContext?.save()
            }
            catch {
                ErrorAlertView.showError(with: String(describing: error), from: self)
            }
        }
    }
    
    // MARK: - UITableViewDatasource
     
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
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return NSLocalizedString("Columns", comment: "")
        }
        return nil
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as! NameInputTableViewCell
                    cell.setName(dataset.name)
                    cell.nameFieldChangeDelegate = self
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "StaticValueCell", for: indexPath) as! StaticTextTableViewCell
                    cell.accessoryType = .disclosureIndicator
                    let nameString = NSLocalizedString("Delimiter", comment: "") + " :"
                    let valueString = " \(dataset.delimiter ?? "") "
                    cell.setValueName(nameString , value: valueString)
                    return cell
                case 2:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "StaticValueCell", for: indexPath) as! StaticTextTableViewCell
                    cell.setValueName( NSLocalizedString("File Id", comment: ""), value: dataset.uuid)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 1 {
            let viewController = DelimiterSelectionTableViewController()
            viewController.selectionDelegate = self
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    // MARK: - DelimiterSelectionDelegate
    
    func delimiterSelected(delimiter: Delimiter) {
        dataset.delimiter = delimiter.value
        tableView.reloadData()
    }
    
    // MARK: - ObjectNamingProtocol
    
    func objectNameFieldChanged(toString: String?) {
        dataset.name = toString
    }
}
