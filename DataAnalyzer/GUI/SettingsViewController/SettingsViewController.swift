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
    
    // MARK: - View
    
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
        
        self.dismiss(animated: true)
    }
        
    // MARK: - UITableViewDatasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = item
        return cell
        
    }
    
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
