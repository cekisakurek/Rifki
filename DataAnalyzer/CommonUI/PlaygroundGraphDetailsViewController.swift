//
//  PlaygroundGraphDetailsViewController.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 11.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit

enum GraphDetailsSection {
    case NameTypeSection
    case Dataset
}

enum GraphMandatorySection: Int {
    case Name
    case GraphType
    case Data
    case yAxis
    
    
}

protocol PlaygroundGraphDetailsDelegate: class {
    
    func graphNameChanged(toString: String?)
}

protocol PlaygroundGraphDetailsDatasource: class {
    
    func graphType() -> PlaygroundGraphType
    
    func graphDatasets() -> [GraphDataSet]
}


class PlaygroundGraphDetailsViewController: UITableViewController, ObjectNamingProtocol {
    
    weak var coordinator: CreateGraphCoordinator?
    weak var graphDetailsDelegate: PlaygroundGraphDetailsDelegate?
    weak var graphDetailsDatasource: PlaygroundGraphDetailsDatasource?
    
    func objectNameFieldChanged(toString: String?) {
        graphDetailsDelegate?.graphNameChanged(toString: toString)
    }
    
    
    
    var sections: [GraphDetailsSection] = [.NameTypeSection, .Dataset]
    
    @objc func cancelled() {
        self.coordinator?.cancel()
    }
    
    @objc func save() {
        self.coordinator?.save()
    }
    
    override func loadView() {
        super.loadView()
        
        let cancelItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(cancelled))
        self.navigationItem.leftBarButtonItem = cancelItem
        
        let saveItem = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .plain, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem = saveItem
        
        
        self.tableView.estimatedRowHeight = 100.0;
        self.tableView.register(NameInputTableViewCell.self, forCellReuseIdentifier: "NameCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.register(StaticTextTableViewCell.self, forCellReuseIdentifier: "StaticValueCell")
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return NSLocalizedString("Datasets", comment: "")
        }
        return nil
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch sections[section] {
        case .NameTypeSection:
            return 2
        case .Dataset:
            return self.graphDetailsDatasource!.graphDatasets().count + 1
        default:
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = sections[indexPath.section]
        
        switch section {
            case .NameTypeSection:
                switch indexPath.item {
                case GraphMandatorySection.Name.rawValue:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as! NameInputTableViewCell
                    cell.setName("New Graph")
                    cell.nameFieldChangeDelegate = self
                    return cell
                case GraphMandatorySection.GraphType.rawValue:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "StaticValueCell", for: indexPath) as! StaticTextTableViewCell
                    
                    let nameString = NSLocalizedString("Type", comment: "") + " :"
                    let valueString = self.graphDetailsDatasource!.graphType().rawValue
                    cell.setValueName(nameString, value: valueString)
                    
                    return cell
                default:
                    break;
                }
            case .Dataset:
                let cell = tableView.dequeueReusableCell(withIdentifier: "StaticValueCell", for: indexPath) as! StaticTextTableViewCell
                
                if indexPath.row == 0 {
                    let nameString = NSLocalizedString("Add Dataset", comment: "")
                    let valueString = ""
                    cell.setValueName(nameString, value: valueString)
                }
                else {
                    let dataset = self.graphDetailsDatasource?.graphDatasets()[indexPath.row - 1]
//                    let nameString = dataset!.name
//                    let valueString = ""
//                    cell.setValueName(nameString, value: valueString)
                }
                
                
                
                return cell

            default:
                break
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
        
    }
    
    
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = sections[indexPath.section]
        switch section {
        case .Dataset:
//            self.coordinator!.createDataset()
            break
            
        default:
            break
        }
        
//        if indexPath.section == GraphDetailsSection.Dataset && indexPath.row == 0 {
////            let viewController = DelimiterSelectionTableView()
////            viewController.selectionDelegate = self
////            self.navigationController?.pushViewController(viewController, animated: true)
//        }
        
    }
}
