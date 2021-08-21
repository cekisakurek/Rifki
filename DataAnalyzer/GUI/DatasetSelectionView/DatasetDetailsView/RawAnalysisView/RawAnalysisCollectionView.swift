//
//  RawAnalysisCollectionView.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 19.08.21.
//  Copyright © 2021 cekisakurek. All rights reserved.
//

import SwiftUI

// MARK: - IndexPath
private extension IndexPath {
    init(row: Int, column: Int) {
        self = IndexPath(item: column, section: row)
    }
}

struct RawAnalysisCollectionView: UIViewRepresentable  {
    
    private let leftAndRightPaddings: CGFloat = 10.0
        
    static let cellReuseIdentifier = "collectionCell"
    
    private let datasource: RawAnalysisCollectionViewDatasource
    private let delegate: RawAnalysisCollectionViewDelegate
    
    var objectID: NSManagedObjectID
    
    init(objectID: NSManagedObjectID) {
        self.objectID = objectID
        
        self.delegate = RawAnalysisCollectionViewDelegate()
        self.datasource = RawAnalysisCollectionViewDatasource(objectID: objectID)
    }
        
    func makeUIView(context: Context) -> UICollectionView {
        
        let flowLayout = GridCollectionViewLayout()
        flowLayout.minimumInteritemSpacing = self.leftAndRightPaddings/2.0
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        flowLayout.itemSize = CGSize(width: 100.0, height: 50.0)
        
        flowLayout.columnCount = 0
        flowLayout.rowCount = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RawDataCollectionViewCell.self, forCellWithReuseIdentifier: RawAnalysisCollectionView.cellReuseIdentifier)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self.delegate
        collectionView.dataSource = self.datasource
        self.datasource.collectionView = collectionView
        
        return collectionView
    }

    func updateUIView(_ uiView: UICollectionView, context: Context) {
        
    }
    
    final class RawAnalysisCollectionViewDatasource: NSObject, UICollectionViewDataSource {
        
        @Environment(\.appTheme) var appTheme: AppTheme
        
        public var rows: [[String]]?
        private var headers: [String]?
        
        var objectID: NSManagedObjectID?
        
        weak var collectionView: UICollectionView? {
            didSet {
                if collectionView != nil {
                    fetchDataset()
                }
            }
        }
        
        init(objectID: NSManagedObjectID) {
            super.init()
            self.objectID = objectID
        }
        
        func fetchDataset() {
            if let objectID = objectID,
               let dataset = Dataset.fetch(in: PersistenceController.shared.viewContext, objectID: objectID) {
                self.rows = dataset.data
                self.headers = dataset.headers
                
                if let collectionView = self.collectionView,
                   let layout = collectionView.collectionViewLayout as? GridCollectionViewLayout {
                    let rowCount = self.rows!.count
                    let columnCount = self.headers!.count
                    layout.columnCount = columnCount + 1
                    layout.rowCount = rowCount + 1
                    collectionView.reloadData()
                }
            }
        }
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            if let items = self.rows {
                return items.count + 1
            }
            return 0
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if let headers = self.headers {
                return headers.count + 1
            }
            return 0
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RawAnalysisCollectionView.cellReuseIdentifier, for: indexPath) as! RawDataCollectionViewCell
            
            cell.backgroundColor = appTheme.rawAnalysis.rawDataCell1Background
            
            if indexPath.item == 0 {
                cell.backgroundColor = appTheme.rawAnalysis.rawDataCell2Background
                if indexPath.section > 0 {
                    cell.setString(string: String(indexPath.section))
                }
                else {
                    cell.setString(string: NSLocalizedString("Row / Header", comment: ""))
                }
                return cell
            }
            
            if let headers = self.headers,
               let rows = self.rows {
                if indexPath.section == 0 {
                    cell.setString(string: headers[indexPath.item - 1])
                    cell.backgroundColor = appTheme.rawAnalysis.rawDataCell2Background
                }
                else {
                    cell.setString(string: (rows[indexPath.section - 1][indexPath.item - 1] ))
                }
            }
            return cell
        }
    }
    final class RawAnalysisCollectionViewDelegate: NSObject, UICollectionViewDelegate {

    }
    
    
    class RawDataCollectionViewCell: UICollectionViewCell {

        private var label: UILabel
        
        override init(frame: CGRect) {
            
            self.label = UILabel(frame: .zero)
            self.label.translatesAutoresizingMaskIntoConstraints = false
            self.label.font = UIFont.systemFont(ofSize: 13)
            self.label.textAlignment = .center
            
            super.init(frame: frame)
            
            self.contentView.layer.borderColor = UIColor.black.cgColor
            self.contentView.layer.borderWidth = 1.0
            
            // TODO: implement dark/light theme
            if #available(iOS 13.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark {
                    self.label.textColor = UIColor.black
                }
                else {
                    self.label.textColor = UIColor.black
                }
            }
            else {
                self.label.textColor = UIColor.white
            }
            self.contentView.addSubview(self.label)
            
            NSLayoutConstraint.activate([
                self.label.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                self.label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                self.label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
                self.label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
            ])
        }

        func setString(string: String?) {
            self.label.text = string
        }
        
        required convenience init?(coder aDecoder: NSCoder) {
            self.init(frame: .zero)
        }
    }
    
    class GridCollectionViewLayout: UICollectionViewFlowLayout {

        var columnCount = 0
        var rowCount = 0
        
        // MARK: - Collection view flow layout methods
        override var collectionViewContentSize: CGSize {
            return CGSize(width: CGFloat(columnCount) * self.itemSize.width, height: CGFloat(rowCount) * self.itemSize.height)
        }

        override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            
            var layoutAttributes = [UICollectionViewLayoutAttributes]()

            if rowCount == 0 {
                return layoutAttributes
            }
            
            let startY = max(Int(ceil((rect.minY)/self.itemSize.height)),0)
            
            
            // calculate next screen
            let endY = min(startY + Int(ceil(rect.height / self.itemSize.height)), rowCount)
            
            
            for row in startY..<endY {
                var xOffset: CGFloat = 100
                let yOffset: CGFloat = CGFloat(row) * self.itemSize.height
                for col in 0..<columnCount {
                    
                    let indexPath = IndexPath(row: row, column: col)
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    
                    if col == 0 {
                        var frame = attributes.frame
                        frame.origin.y = yOffset
                        frame.origin.x += collectionView!.contentOffset.x
                        frame.size = CGSize(width: 100.0, height: 50.0)
                        attributes.frame = frame
                        attributes.zIndex = 99
                        layoutAttributes.append(attributes)
                    }
                    else {
                        
                        attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height)
                        layoutAttributes.append(attributes)
                        xOffset += itemSize.width
                    }
                }
            }
            
            // header
            for col in 0..<columnCount {
                let headerIndexPath = IndexPath(row: 0, column: col)
                let headerAttributes = UICollectionViewLayoutAttributes(forCellWith: headerIndexPath)
                var frame = headerAttributes.frame
                frame.origin.y += collectionView!.contentOffset.y
                frame.origin.x = (CGFloat(col) * 100.0)
                frame.size = CGSize(width: 100.0, height: 50.0)
                headerAttributes.frame = frame
                headerAttributes.zIndex = 100
                layoutAttributes.append(headerAttributes)
            }
            
            
            // 0-0 is always there
            
            let headerIndexPath = IndexPath(row: 0, column: 0)
            let headerAttributes = UICollectionViewLayoutAttributes(forCellWith: headerIndexPath)
            var frame = headerAttributes.frame
            frame.origin.y += collectionView!.contentOffset.y
            frame.origin.x += collectionView!.contentOffset.x
            frame.size = CGSize(width: 100.0, height: 50.0)
            headerAttributes.frame = frame
            headerAttributes.zIndex = 105
            layoutAttributes.append(headerAttributes)
            
            
            
            return layoutAttributes
        }

        override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
            return true
        }
    }
}
