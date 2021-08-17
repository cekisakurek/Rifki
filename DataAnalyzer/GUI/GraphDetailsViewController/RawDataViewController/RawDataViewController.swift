//
//  RawDataViewController.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 01.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit
import CSV

class RawDataViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    private var collectionView: UICollectionView!
    
    private let leftAndRightPaddings: CGFloat = 10.0
        
    private let cellReuseIdentifier = "collectionCell"
    
    private var appTheme = AppTheme()
    
    public var dataset: GraphRawData? {
        didSet {
            if let dataset = dataset {
                let rowCount = (dataset.rows.count)
                let columnCount = (dataset.headers?.count)!
                                
                let layout = self.collectionView.collectionViewLayout as! GridCollectionViewLayout
                layout.columnCount = columnCount + 1
                layout.rowCount = rowCount + 1
                layout.invalidateLayout()
                self.collectionView.reloadData()
            }
            else {
                let layout = self.collectionView.collectionViewLayout as! GridCollectionViewLayout
                layout.columnCount = 0
                layout.rowCount = 0
                layout.invalidateLayout()
                self.collectionView.reloadData()
            }
        }
    }

    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.red
        
        let flowLayout = GridCollectionViewLayout()
        flowLayout.minimumInteritemSpacing = self.leftAndRightPaddings/2.0
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        flowLayout.itemSize = CGSize(width: 100.0, height: 50.0)
        
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.register(RawDataCollectionViewCell.self, forCellWithReuseIdentifier: self.cellReuseIdentifier)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.white
        self.view.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let items = self.dataset?.rows {
            return items.count + 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let headers = self.dataset?.headers {
            return headers.count + 1
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! RawDataCollectionViewCell
        cell.backgroundColor = self.appTheme.rawDataCell1Background
        
        if indexPath.item == 0 {
            cell.backgroundColor = self.appTheme.rawDataCell2Background
            if indexPath.section > 0 {
                cell.setString(string: String(indexPath.section))
            }
            else {
                cell.setString(string: NSLocalizedString("Row / Header", comment: ""))
            }
            return cell
        }
        
        if let dataset = self.dataset {
            if indexPath.section == 0 {
                cell.setString(string: dataset.headers?[indexPath.item - 1])
                cell.backgroundColor = self.appTheme.rawDataCell2Background
            }
            else {
                cell.setString(string: (dataset.rows[indexPath.section - 1][indexPath.item - 1] as! String))
            }
        }
        return cell
    }
    
    // TODO: Implement row errors
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        if let cell = collectionView.cellForItem(at: indexPath) {
//            cell.backgroundColor = UIColor.red
//        }
//    }
}
