//
//  HeatmapViewModel.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 19.08.21.
//  Copyright © 2021 cekisakurek. All rights reserved.
//

import Combine
import Foundation
import SigmaSwiftStatistics
import Charts
import UIKit

class StructWrapper<T>: NSObject {
    let value: T

    init(_ _struct: T) {
        self.value = _struct
    }
}

class HeatmapViewModel: ObservableObject {
    
    let cache = NSCache<NSString, StructWrapper<HeatmapResult>>()
    
    @Published var heatmapResult: HeatmapResult?
    
    private func checkCache(of objectID: NSManagedObjectID) -> HeatmapResult? {
        
        if let cachedVersion = cache.object(forKey: objectID.uriRepresentation().absoluteString as NSString) {
            // use the cached version
            self.heatmapResult = cachedVersion.value
        }
        return nil
    }
    
    func calculateHeatmap(of objectID: NSManagedObjectID) {
        
        if let cached = checkCache(of: objectID) {
            DispatchQueue.main.async {
                self.heatmapResult = cached
            }
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            
            guard let self = self else { return }
            
            let context = PersistenceController.shared.writeContext
            if let dataset = Dataset.fetch(in: context, objectID: objectID) {
                let result = self._calculateHeatmap(dataset: dataset)
                let cachedVersion = StructWrapper(result)
                
                self.cache.setObject(cachedVersion, forKey: objectID.uriRepresentation().absoluteString as NSString)
                
                // Bounce back to the main thread to update the UI
                DispatchQueue.main.async {
                    self.heatmapResult = result
                }
            }
            else {
                DispatchQueue.main.async {
                    self.heatmapResult = nil
                }
            }
        }
    }
    
    func _calculateHeatmap(dataset: Dataset) -> HeatmapResult {
        
        var labels = [String]()
        var indices = [Int]()
        for (i, header) in dataset.headers!.enumerated() {
            
            let column = ColumnAnalysis(data: dataset.data!, index: i, name: header)
            if header != "Id" {
                if column.type == .Int || column.type == .Double {
                    labels.append(dataset.headers![i])
                    indices.append(i)
                }
            }
            
        }
        
        let hCount = Int(labels.count)
        var corr = [[Double]](repeating: [0.0], count: hCount)
        
        var minValue = Double.greatestFiniteMagnitude
        var maxValue = 0.0
        
        let temp = [Double](repeating: 0, count: dataset.data!.count)
        var columns = [[Double]](repeating: temp, count: indices.count)
        for (columnIndex, columnName) in labels.enumerated() {
            let column = ColumnAnalysis.getColumnData(data: dataset.data!, index: dataset.headers!.firstIndex(of: columnName)!)
            columns[columnIndex] = column
        }
        
        for (columnIndex, column) in columns.enumerated() {
            var rowCorr = [Double](repeating: 0.0, count: labels.count)
            for (rowIndex, row) in columns.enumerated() {
                var c = 0.0
                if columnIndex == rowIndex {
                    c = 1.0
                }
                else {
                    if let pearson = Sigma.pearson(x: row , y: column) {
                        c = pearson
                    }
                    c = c.roundedUp(toPlaces: 4)
                }

                if c < minValue  {
                    minValue = c
                }
                if c > maxValue {
                    maxValue = c
                }
                rowCorr[rowIndex] = c

            }
            corr[columnIndex] = rowCorr
        }
        
        let result = HeatmapResult(labels: labels, matrix: corr)
        return result
    }
    
    struct HeatmapResult {
        var labels: [String]
        var matrix: [[Double]]
    }
}
