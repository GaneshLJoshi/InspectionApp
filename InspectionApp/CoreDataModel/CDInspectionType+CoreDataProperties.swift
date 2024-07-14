//
//  CDInspectionType+CoreDataProperties.swift
//  InspectionApp
//
//  Created by Ganesh Joshi on 13/07/24.
//
//

import Foundation
import CoreData


extension CDInspectionType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDInspectionType> {
        return NSFetchRequest<CDInspectionType>(entityName: "CDInspectionType")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var access: String?
    @NSManaged public var cdInspection: CDInspection?

}

extension CDInspectionType : Identifiable {

}
