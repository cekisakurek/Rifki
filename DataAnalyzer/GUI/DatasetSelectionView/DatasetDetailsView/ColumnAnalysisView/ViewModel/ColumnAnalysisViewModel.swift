//
//  ColumnAnalysisViewModel.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 19.08.21.
//  Copyright © 2021 cekisakurek. All rights reserved.
//


import Combine
import Foundation
import SigmaSwiftStatistics
import Charts
import CoreData

class ColumnAnalysisViewModel: ObservableObject {
    
    
    @Published var histogramResult: HistorgramResult?
    @Published var probabilityResult: ProbabilityResult?
    @Published var descriptionResult: DescriptionResult?
    
    @Published var calculatingDistribution = false
    @Published var calculatingProbability = false
    @Published var calculatingDescription = false
    
    @Published var headers = [String]()
    
    private var dataset: Dataset?
    
    var objectID: NSManagedObjectID? {
        didSet {
            if objectID != nil {
                fetchDataset()
            }
        }
    }
    
    func fetchDataset() {
        if let objectID = objectID,
           let dataset = Dataset.fetch(in: PersistenceController.shared.viewContext, objectID: objectID) {
            self.headers = dataset.headers ?? []
            self.dataset = dataset
        }
    }
    
    func calculateDistribution(of columnName: String) {
        
        self.histogramResult = nil
        self.calculatingDistribution = true
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            
            guard let self = self else { return }
            
            if let dataset = self.dataset {
                let r = self.dataset!.headers?.firstIndex(of: columnName)
                let columnAnalysis = ColumnAnalysis(data: dataset.data!, index: r!, name: columnName)
                
                if columnAnalysis.type == .Double || columnAnalysis.type == .Int {
                    let result = HistogramCalculator.calculate(column: columnAnalysis)
                    // Bounce back to the main thread to update the UI
                    DispatchQueue.main.async {
                        self.histogramResult = result
                        self.calculatingDistribution = false
                    }
                }
            }  
        }
    }
    
    func calculateProbability(of columnName: String) {
        
        self.probabilityResult = nil
        self.calculatingProbability = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            
            guard let self = self else { return }
            if let dataset = self.dataset {
                let r = self.dataset!.headers?.firstIndex(of: columnName)
                let columnAnalysis = ColumnAnalysis(data: dataset.data!, index: r!, name: columnName)
                if columnAnalysis.type == .Double || columnAnalysis.type == .Int || columnAnalysis.type == .String {
                    let result = ProbabilityCalculator.calculate(column: columnAnalysis)
                    // Bounce back to the main thread to update the UI
                    DispatchQueue.main.async {
                        self.probabilityResult = result
                        self.calculatingProbability = false
                    }
                }
            }
        }
    }
    
    func calculateDescription(of columnName: String) {
        
        self.descriptionResult = nil
        self.calculatingDescription = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            guard let self = self else { return }
            if let dataset = self.dataset {
                let r = dataset.headers?.firstIndex(of: columnName)
                
                let columnAnalysis = ColumnAnalysis(data: dataset.data!, index: r!, name: columnName)
                if columnAnalysis.type == .Double || columnAnalysis.type == .Int {
                    let result = DescriptionCalculator.calculate(column: columnAnalysis)
                    // Bounce back to the main thread to update the UI
                    DispatchQueue.main.async {
                        self.descriptionResult = result
                        self.calculatingDescription = false
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

