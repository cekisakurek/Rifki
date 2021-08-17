//
//  DelimiterSelectionTableView.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 29.04.20.
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

class DelimiterSelectionTableViewController: UITableViewController {
    
    private let delimiters: [Delimiter] = [comma, semicolon, tab, colon, pipe]
    
    weak var selectionDelegate: DelimiterSelectionDelegate?
    
    // MARK: - View
    
    override func loadView() {
        super.loadView()
        
        self.tableView.estimatedRowHeight = 100.0;
        self.tableView.register(NameInputTableViewCell.self, forCellReuseIdentifier: "NameCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.register(StaticTextTableViewCell.self, forCellReuseIdentifier: "StaticValueCell")
        
    }
    
    // MARK: - UITableViewDatasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delimiters.count
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
