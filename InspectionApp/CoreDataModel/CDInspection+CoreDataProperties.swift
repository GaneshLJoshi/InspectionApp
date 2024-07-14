//
//  CDInspection+CoreDataProperties.swift
//  InspectionApp
//
//  Created by Ganesh Joshi on 13/07/24.
//
//

import Foundation
import CoreData


extension CDInspection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDInspection> {
        return NSFetchRequest<CDInspection>(entityName: "CDInspection")
    }

    @NSManaged public var id: Int32
    @NSManaged public var cdInspectionType: CDInspectionType?
    @NSManaged public var cdArea: CDArea?
    @NSManaged public var cdSurvey: CDSurvey?
    @NSManaged public var cdUser: CDUser?

}

extension CDInspection : Identifiable {

}
