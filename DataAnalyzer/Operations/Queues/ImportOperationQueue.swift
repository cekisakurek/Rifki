//
//  ImportOperation.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 31.03.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import Foundation

class ImportOperation {
    lazy var queue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "import queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}

typealias CalculationHandler = (_ data: HistorgramResult?, _ indexPath: IndexPath?, _ error: Error?) -> Void

typealias ProbabilityDistributionCalculationHandler = (_ data: ProbabilityResult?, _ indexPath: IndexPath?, _ error: Error?) -> Void

typealias HeatMapCalculationHandler = (_ data: HeatMapResult?, _ error: Error?) -> Void

class CalculationsOperationQueue {
    
    private lazy var queue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "calc queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    func calculateHeatMap(_ dataset: GraphRawData, handler: @escaping HeatMapCalculationHandler) {
        
        let hash = String("heatmap")
        
        if let operations = (self.queue.operations as? [ProbabilityDataCalculator])?.filter({$0.identifier == hash && $0.isFinished == false && $0.isExecuting == true }), let operation = operations.first {
            operation.queuePriority = .veryHigh
        }
        else {
            let operation = HeatMapCalculator(dataset: dataset, identifier: hash)
            self.queue.addOperation(operation)
            operation.completionBlock = {
                DispatchQueue.main.async {
                    handler(operation.result, nil)
                }
            }
        }
    }
    
    func calculateProbabilityDistribution(_ data: [Double], indexPath: IndexPath?, handler: @escaping ProbabilityDistributionCalculationHandler) {
        
        let hash = String(indexPath.hashValue)
        
        if let operations = (self.queue.operations as? [ProbabilityDataCalculator])?.filter({$0.identifier == hash && $0.isFinished == false && $0.isExecuting == true }), let operation = operations.first {
            operation.queuePriority = .veryHigh
        }
        else {
            let operation = ProbabilityDataCalculator(data: data, identifier: hash)
            self.queue.addOperation(operation)
            operation.completionBlock = {
                DispatchQueue.main.async {
                    handler(operation.result, indexPath, nil)
                }
            }
        }
    }
    
    func calculateDistribution(_ data: [Double], indexPath: IndexPath?, handler: @escaping CalculationHandler) {
        
        let hash = String(indexPath.hashValue)
        
        if let operations = (self.queue.operations as? [HistogramCalculator])?.filter({$0.identifier == hash && $0.isFinished == false && $0.isExecuting == true }), let operation = operations.first {
            operation.queuePriority = .veryHigh
        }
        else {
            
            let operation = HistogramCalculator(data: data, identifier: hash)
            self.queue.addOperation(operation)
            operation.completionBlock = {
                DispatchQueue.main.async {
                    handler(operation.result, indexPath, nil)
                }       
            }
        }
    }
}
