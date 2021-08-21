//
//  AddGraphViewModel.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 21.08.21.
//  Copyright © 2021 cekisakurek. All rights reserved.
//

import CoreData
import SwiftUI


enum PlaygroundGraphType: String {
    case None
    case Line
    case Bar
    case Scatter
}

class AddGraphViewModel: ObservableObject {
    
    var xAxis: String?
    var yAxis: String?
    var type: PlaygroundGraphType?
    
    @Published var headers: [String] = []
    
    @Published var saved: Bool = false
    
    @Environment(\.appTheme) var appTheme: AppTheme
    
    private var dataset: Dataset?
    
    var objectID: NSManagedObjectID? {
        didSet {
            if objectID != nil {
                fetchDataset()
            }
        }
    }
    
    func fetchDataset() {
        let context = PersistenceController.shared.viewContext
        if let objectID = objectID {
            self.dataset = Dataset.fetch(in: context, objectID: objectID)
            self.headers = self.dataset!.headers!
        }
    }
    
    func save(xAxis: String, yAxis: String, type: PlaygroundGraphType, name: String?) {
       
        if let dataset = self.dataset {
            
            let context = PersistenceController.shared.viewContext
            let graphObject = NSEntityDescription.insertNewObject(forEntityName: "Graph", into: context) as! Graph
            
            let currentDate = Date()

            if name != "" {
                graphObject.name = name
            }
            else {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .medium
                graphObject.name = formatter.string(from: currentDate)
            }
            let uuid = UUID().uuidString
            graphObject.uuid = uuid
            graphObject.type = type.rawValue
            graphObject.workset = dataset
            
            let graphData = NSEntityDescription.insertNewObject(forEntityName: "GraphData", into: context) as! GraphData

            graphObject.xAxisName = xAxis
            graphObject.yAxisName = yAxis
         
            graphData.xAxis = xAxis
            graphData.yAxis = yAxis

            switch type {
            case .Bar:
                break
            case .Line:
                graphData.lineWidth = appTheme.playground.userGraph.lineWidth
//                graphData.lineColor = appTheme.playground.userGraph.lineColor
            case .Scatter:
                graphData.circleSize = appTheme.playground.userGraph.circleSize
//                graphData.circleColor = appTheme.playground.userGraph.circleColor
            case .None:
                break
            }
            graphObject.addToData(graphData)
            try? context.save()
            self.saved = true
        }
    }
}
