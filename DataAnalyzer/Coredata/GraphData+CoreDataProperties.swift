//
//  GraphData+CoreDataProperties.swift
//  
//
//  Created by Cihan Emre Kisakurek on 11.04.20.
//
//

import Foundation
import CoreData


extension GraphData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GraphData> {
        return NSFetchRequest<GraphData>(entityName: "GraphData")
    }

    @NSManaged public var name: String?
    @NSManaged public var axis: String?

}
