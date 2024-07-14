//
//  CDUser+CoreDataProperties.swift
//  InspectionApp
//
//  Created by Ganesh Joshi on 13/07/24.
//
//

import Foundation
import CoreData


extension CDUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDUser> {
        return NSFetchRequest<CDUser>(entityName: "CDUser")
    }

    @NSManaged public var email: String?
    @NSManaged public var pastScores: NSSet?
    @NSManaged public var cdInspection: CDInspection?

}

// MARK: Generated accessors for pastScores
extension CDUser {

    @objc(addPastScoresObject:)
    @NSManaged public func addToPastScores(_ value: CDPastScores)

    @objc(removePastScoresObject:)
    @NSManaged public func removeFromPastScores(_ value: CDPastScores)

    @objc(addPastScores:)
    @NSManaged public func addToPastScores(_ values: NSSet)

    @objc(removePastScores:)
    @NSManaged public func removeFromPastScores(_ values: NSSet)

}

extension CDUser : Identifiable {

}
