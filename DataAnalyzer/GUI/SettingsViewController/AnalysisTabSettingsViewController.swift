//
//  DistributionGraphSettingsViewController.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 13.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit
import CoreData

enum AnalysisTabSettingsGraphs: Int {
    case Distribution = 0
    case Probability = 1    
    static func sectionCount() -> Int { return 2 }
}

class AnalysisTabSettingsViewController: UITableViewController {
    
    
    var frequencyLineDelegate = DistributionGraphFrequencyLineWidthDelegate()
    var normalLineDelegate = DistributionGraphNormalLineWidthDelegate()
    
    var probabilityNormalLineDelegate = ProbabilityGraphNormalLineWidthDelegate()
    
    var settings: Settings?
    
    let distributionGraphItems = [NSLocalizedString("Background Color", comment: ""),
                                  NSLocalizedString("X-Axis Text Color", comment: ""),
                                  NSLocalizedString("Y-Axis Text Color", comment: ""),
                                  NSLocalizedString("Bar Color", comment: ""),
                                  NSLocalizedString("Frequency Line Color", comment: ""),
                                  NSLocalizedString("Frequency Line Width", comment: ""),
                                  NSLocalizedString("Normal Line Color", comment: ""),
                                  NSLocalizedString("Normal Line Width", comment: "")
    ]
    
    let probabilityGraphItems = [NSLocalizedString("Background Color", comment: ""),
                                 NSLocalizedString("X-Axis Text Color", comment: ""),
                                 NSLocalizedString("Y-Axis Text Color", comment: ""),
                                 NSLocalizedString("Circle Color", comment: ""),
                                 NSLocalizedString("Normal Line Color", comment: ""),
                                 NSLocalizedString("Normal Line Width", comment: "")
    ]
    
    // MARK: - View
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.white
        
        self.title = NSLocalizedString("Analysis Tab Settings", comment: "")
        
        self.tableView.estimatedRowHeight = 100.0;
        self.tableView.register(NameInputTableViewCell.self, forCellReuseIdentifier: "NameCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.register(ColorSelectionTableViewCell.self, forCellReuseIdentifier: ColorSelectionTableViewCell.identifier)
        self.tableView.register(DoubleValueInputTableViewCell.self, forCellReuseIdentifier: DoubleValueInputTableViewCell.identifier)
        
        
        do {
            let context = CoreDataController.shared.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
            let settings = try context.fetch(fetchRequest) as! [Settings]
            if let settingsObject = settings.first {
                self.settings = settingsObject
                self.frequencyLineDelegate.settings = self.settings
                self.normalLineDelegate.settings = self.settings
                self.probabilityNormalLineDelegate.settings = self.settings
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
    
    // MARK: - UITableViewDatasource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return AnalysisTabSettingsGraphs.sectionCount()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if AnalysisTabSettingsGraphs(rawValue: section) == .Distribution {
            return distributionGraphItems.count
        }
        else if AnalysisTabSettingsGraphs(rawValue: section) == .Probability {
            return probabilityGraphItems.count
        }
        return 0
    }
    
    // MARK: - UITableViewDelegate
    
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if AnalysisTabSettingsGraphs(rawValue: indexPath.section) == .Distribution {
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
        else if AnalysisTabSettingsGraphs(rawValue: indexPath.section) == .Probability {
            let item = probabilityGraphItems[indexPath.row]
            
            if let color = probabilityGraphColorForIndex(indexPath.row) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ColorCell", for: indexPath) as! ColorSelectionTableViewCell
                cell.accessoryType = .disclosureIndicator
                cell.setValueName(item, color: color)
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DoubleValueCell", for: indexPath) as! DoubleValueInputTableViewCell
                cell.accessoryType = .none
                if indexPath.row == 5 {
                    cell.valueFieldChangeDelegate = self.probabilityNormalLineDelegate
                }
                
                let value = probabilityGraphValueForIndex(indexPath.row)
                cell.setValueName(item, value: value)
                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.accessoryType = .none
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let pickerViewController = ColorPickerViewController()
        pickerViewController.fromIndexPath = indexPath
        pickerViewController.tableColorDelegate = self
        self.navigationController?.pushViewController(pickerViewController, animated: true)
        
    }
    
    // MARK: - Distribution Graph Delegates
    
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
    
    // MARK: - Probability Graph Delegates
    
    class ProbabilityGraphNormalLineWidthDelegate: ObjectValueInputProtocol {
        
        weak var settings: Settings?
        
        func valueInputFieldChanged(toValue: Double?) {
            if let settings = settings,
                let value = toValue {
                settings.pgNormalLineWidth = value
            }
        }
    }
    
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
    
    func probabilityGraphValueForIndex(_ index: Int) -> Double? {
        switch index {
            case 5:
                return Double(settings!.pgNormalLineWidth)
            default:
                return nil
        }
    }
    
    func probabilityGraphColorForIndex(_ index: Int) -> UIColor? {
        switch index {
            case 0:
                return settings?.pgBackgroundColor as? UIColor
            case 1:
                return settings?.pgXAxisTextColor as? UIColor
            case 2:
                return settings?.pgYAxisTextColor as? UIColor
            case 3:
                return settings?.pgCircleColor as? UIColor
            case 4:
                return settings?.pgNormalLineColor as? UIColor
            default:
                return nil
        }
    }
    
    func probabilityGraphChangeColor(_ color: UIColor, index: Int) {
        switch index {
            case 0:
                settings?.pgBackgroundColor = color
            case 1:
                settings?.pgXAxisTextColor = color
            case 2:
                settings?.pgYAxisTextColor = color
            case 3:
                settings?.pgCircleColor = color
            case 4:
                settings?.pgNormalLineColor = color
            default:
                break;
        }
    }
}


extension AnalysisTabSettingsViewController: ColorPickerFromTableViewDelegate {
    
    func colorPicker(_ picker: ColorPickerViewController, didChange color: UIColor, forIndexPath: IndexPath) {
        if forIndexPath.section == 0 {
            distributionGraphChangeColor(color, index: forIndexPath.row)
        }
        else if forIndexPath.section == 1 {
            probabilityGraphChangeColor(color, index: forIndexPath.row)
        }
        
        tableView.reloadData()
    }
}
