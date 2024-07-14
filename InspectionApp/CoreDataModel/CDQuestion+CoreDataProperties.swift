//
//  CDQuestion+CoreDataProperties.swift
//  InspectionApp
//
//  Created by Ganesh Joshi on 13/07/24.
//
//

import Foundation
import CoreData


extension CDQuestion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDQuestion> {
        return NSFetchRequest<CDQuestion>(entityName: "CDQuestion")
    }

    @NSManaged public var name: String?
    @NSManaged public var selectedAnswerChoiceId: Int32
    @NSManaged public var id: Int32
    @NSManaged public var cdanswerChoices: NSSet?
    @NSManaged public var cdcategory: CDCategory?

}

// MARK: Generated accessors for cdanswerChoices
extension CDQuestion {

    @objc(addCdanswerChoicesObject:)
    @NSManaged public func addToCdanswerChoices(_ value: CDAnswerChoice)

    @objc(removeCdanswerChoicesObject:)
    @NSManaged public func removeFromCdanswerChoices(_ value: CDAnswerChoice)

    @objc(addCdanswerChoices:)
    @NSManaged public func addToCdanswerChoices(_ values: NSSet)

    @objc(removeCdanswerChoices:)
    @NSManaged public func removeFromCdanswerChoices(_ values: NSSet)

}

extension CDQuestion : Identifiable {

}
