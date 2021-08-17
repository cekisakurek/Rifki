//
//  HeatmapSettingsViewController.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 13.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit
import CoreData

class HeatmapSettingsViewController: UITableViewController {
    
    class HeatmalShowValueSelectionDelegate: ObjectBooleanInputProtocol {
        
        weak var settings: Settings?
        
        func valueInputFieldChanged(toValue: Bool) {
            if let settings = settings {
                settings.heatmapValuesVisible = toValue
            }
        }
    }
    
    var settings: Settings?
    var heatmapShowValueSelectionDelegate = HeatmalShowValueSelectionDelegate()
    
    let items = [NSLocalizedString("Maximum Color", comment: ""),
                 NSLocalizedString("Minimum Color", comment: ""),
                 NSLocalizedString("Show Values", comment: ""),
                 
    ]
    
    func heatmapChangeColor(_ color: UIColor, index: Int) {
        switch index {
            case 0:
                settings?.heatmapMaxColor = color
            case 1:
                settings?.heatmapMinColor = color
            default:
                break;
        }
    }
    
    func heatmapGraphColorForIndex(_ index: Int) -> UIColor? {
        switch index {
            case 0:
                return settings?.heatmapMaxColor as? UIColor
            case 1:
                return settings?.heatmapMinColor as? UIColor
            default:
                return nil
        }
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.white
        
        self.title = NSLocalizedString("Heatmap Tab Settings", comment: "")
        
        self.tableView.estimatedRowHeight = 100.0;
        self.tableView.register(NameInputTableViewCell.self, forCellReuseIdentifier: "NameCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.register(ColorSelectionTableViewCell.self, forCellReuseIdentifier: ColorSelectionTableViewCell.identifier)
        self.tableView.register(BoolValueInputTableViewCell.self, forCellReuseIdentifier: "BoolValueCell")
        
        
        do {
            let context = CoreDataController.shared.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
            let settings = try context.fetch(fetchRequest) as! [Settings]
            if let settingsObject = settings.first {
                self.settings = settingsObject
                self.heatmapShowValueSelectionDelegate.settings = self.settings
            }
        }
        catch {
            ErrorAlertView.showError(with: String(describing: error), from: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            try CoreDataController.shared.writeContext.save()
        }
        catch {
            ErrorAlertView.showError(with: String(describing: error), from: self)
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
                    
        if let color = heatmapGraphColorForIndex(indexPath.row) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ColorCell", for: indexPath) as! ColorSelectionTableViewCell
            cell.accessoryType = .disclosureIndicator
            cell.setValueName(item, color: color)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BoolValueCell", for: indexPath) as! BoolValueInputTableViewCell
            cell.accessoryType = .none
            if indexPath.row == 2 {
                cell.valueSwitchChangeDelegate = self.heatmapShowValueSelectionDelegate
                cell.setValueName(item, value: settings!.heatmapValuesVisible)
            }
            return cell
        }    
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let pickerViewController = ColorPickerViewController()
        pickerViewController.fromIndexPath = indexPath
        pickerViewController.tableColorDelegate = self
        self.navigationController?.pushViewController(pickerViewController, animated: true)
        
    }
}

extension HeatmapSettingsViewController: ColorPickerFromTableViewDelegate {
    
    func colorPicker(_ picker: ColorPickerViewController, didChange color: UIColor, forIndexPath: IndexPath) {
        if forIndexPath.section == 0 {
            heatmapChangeColor(color, index: forIndexPath.row)
        }
        else if forIndexPath.section == 1 {
            heatmapChangeColor(color, index: forIndexPath.row)
        }
        
        tableView.reloadData()
    }
}
