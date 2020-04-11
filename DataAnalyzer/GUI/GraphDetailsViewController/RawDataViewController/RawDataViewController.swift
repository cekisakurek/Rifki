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
    
    let leftAndRightPaddings: CGFloat = 10.0
    var numberOfItemsPerRow: Int = 0
    private let cellReuseIdentifier = "collectionCell"
    
    var dataset: GraphRawData? {
        didSet {
            
            let rowCount = (dataset?.rows.count)!
            let columnCount = (dataset?.headers?.count)!
            
            numberOfItemsPerRow = columnCount
            
            let layout = collectionView.collectionViewLayout as! GridCollectionViewLayout
            layout.columnCount = columnCount + 1
            layout.rowCount = rowCount + 1
            layout.invalidateLayout()


            collectionView.reloadData()
        }
        
    }

    
    override func loadView() {
        super.loadView()
        let flowLayout = GridCollectionViewLayout()
//        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = leftAndRightPaddings/2.0
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        flowLayout.itemSize = CGSize(width: 100.0, height: 50.0)
//        flowLayout.headerReferenceSize = CGSize(width: self.collectionView.frame.size.width, height: 100)

        
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.register(GraphDetailsValueCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
//        self.collectionView.bounces = false
        
        //        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView")

        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.lightGray
        
        
        
        self.view.addSubview(self.collectionView)
        
        let defaultConstraints = [
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(defaultConstraints)
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if let items = dataset?.rows {
            return items.count + 1
        }
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return dataset!.headers!.count + 1
        
        
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! GraphDetailsValueCell
        cell.backgroundColor = UIColor.white
        if indexPath.item == 0 {
            cell.backgroundColor = UIColor.gray
            if indexPath.section > 0 {
                cell.setString(string: String(indexPath.section))
                
            }
            else {
                cell.setString(string: NSLocalizedString("Row / Header", comment: ""))
                
            }
            
            return cell
        }
        
        if indexPath.section == 0 {
            cell.setString(string: dataset?.headers?[indexPath.item - 1])
            cell.backgroundColor = UIColor.gray
        }
        else {
            cell.setString(string: (dataset?.rows[indexPath.section - 1][indexPath.item - 1] as! String))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath as IndexPath)

        headerView.backgroundColor = UIColor.red

        return headerView
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        
        if section == 0 {
            return CGSize(width: collectionView.frame.size.width, height: 100)
        }
        else {
            return CGSize.zero
        }
        
//        if let headerView = collectionView.visibleSupplementaryViews(ofKind: UICollectionElementKindSectionHeader).first as? CustomHeader {
//            // Layout to get the right dimensions
//            headerView.layoutIfNeeded()
//
//            // Automagically get the right height
//            let height = headerView.contentView.systemLayoutSizeFitting(UILayoutFittingExpandedSize).height
//
//            // return the correct size
//            return CGSize(width: collectionView.frame.width, height: height)
//        }
//
//        // You need this because this delegate method will run at least
//        // once before the header is available for sizing.
//        // Returning zero will stop the delegate from trying to get a supplementary view
        return CGSize(width: collectionView.frame.size.width, height: 100)
    }
    
}
