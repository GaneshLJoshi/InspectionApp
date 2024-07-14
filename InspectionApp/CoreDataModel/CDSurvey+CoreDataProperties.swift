//
//  CDSurvey+CoreDataProperties.swift
//  InspectionApp
//
//  Created by Ganesh Joshi on 13/07/24.
//
//

import Foundation
import CoreData


extension CDSurvey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDSurvey> {
        return NSFetchRequest<CDSurvey>(entityName: "CDSurvey")
    }

    @NSManaged public var id: Int32
    @NSManaged public var cdCategory: NSSet?
    @NSManaged public var cdInspection: CDInspection?

}

// MARK: Generated accessors for cdCategory
extension CDSurvey {

    @objc(addCdCategoryObject:)
    @NSManaged public func addToCdCategory(_ value: CDCategory)

    @objc(removeCdCategoryObject:)
    @NSManaged public func removeFromCdCategory(_ value: CDCategory)

    @objc(addCdCategory:)
    @NSManaged public func addToCdCategory(_ values: NSSet)

    @objc(removeCdCategory:)
    @NSManaged public func removeFromCdCategory(_ values: NSSet)

}

extension CDSurvey : Identifiable {

}
