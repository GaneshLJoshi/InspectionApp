//
//  CDArea+CoreDataProperties.swift
//  InspectionApp
//
//  Created by Ganesh Joshi on 13/07/24.
//
//

import Foundation
import CoreData


extension CDArea {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDArea> {
        return NSFetchRequest<CDArea>(entityName: "CDArea")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var cdInspection: CDInspection?

}

extension CDArea : Identifiable {

}
