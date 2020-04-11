//
//  GraphData+CoreDataProperties.swift
//  
//
//  Created by Cihan Emre Kisakurek on 08.04.20.
//
//

import Foundation
import CoreData


extension GraphData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GraphData> {
        return NSFetchRequest<GraphData>(entityName: "GraphData")
    }

    @NSManaged public var date: Date?
    @NSManaged public var delimiter: String?
    @NSManaged public var localURL: String?
    @NSManaged public var name: String?
    @NSManaged public var remoteURL: String?

}
