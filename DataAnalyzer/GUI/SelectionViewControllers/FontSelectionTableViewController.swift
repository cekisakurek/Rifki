//
//  FontSelectionTableViewController.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 14.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit

protocol FontSelectionDelegate: class {
    func fontSelectionController(_ controller: FontSelectionTableViewController, didSelect font: UIFont)
}

class FontSelectionTableViewController: UITableViewController {
    
    weak var selectionDelegate: FontSelectionDelegate?
    
    // MARK: - View
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.white
        
        self.title = NSLocalizedString("Font Selection", comment: "")
        
        self.tableView.estimatedRowHeight = 100.0;
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    @objc func dismissController() {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SettingsChanged"), object: nil)
        
        self.dismiss(animated: true)
    }
        
    // MARK: - UITableViewDatasource
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let family = UIFont.familyNames[section]
        return family
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return UIFont.familyNames.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let family = UIFont.familyNames[section]
        let fonts = UIFont.fontNames(forFamilyName: family)
        return fonts.count
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        let familiy = UIFont.familyNames[indexPath.section]
        let fonts = UIFont.fontNames(forFamilyName: familiy)
        let fontName = fonts[indexPath.row]
        cell.textLabel?.text = fontName
        
        cell.textLabel?.font = UIFont(name: fontName, size: 18)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let delegate = selectionDelegate {
            let familiy = UIFont.familyNames[indexPath.section]
            let fonts = UIFont.fontNames(forFamilyName: familiy)
            let fontName = fonts[indexPath.row]
            let font = UIFont(name: fontName, size: 18)!
            delegate.fontSelectionController(self, didSelect: font)
        }
        self.navigationController?.popViewController(animated: true)
    }
}



