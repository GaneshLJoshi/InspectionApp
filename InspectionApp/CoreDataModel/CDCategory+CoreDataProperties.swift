//
//  CDCategory+CoreDataProperties.swift
//  InspectionApp
//
//  Created by Ganesh Joshi on 13/07/24.
//
//

import Foundation
import CoreData


extension CDCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCategory> {
        return NSFetchRequest<CDCategory>(entityName: "CDCategory")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var cdQuestions: NSSet?
    @NSManaged public var cdSurvey: CDSurvey?

}

// MARK: Generated accessors for cdQuestions
extension CDCategory {

    @objc(addCdQuestionsObject:)
    @NSManaged public func addToCdQuestions(_ value: CDQuestion)

    @objc(removeCdQuestionsObject:)
    @NSManaged public func removeFromCdQuestions(_ value: CDQuestion)

    @objc(addCdQuestions:)
    @NSManaged public func addToCdQuestions(_ values: NSSet)

    @objc(removeCdQuestions:)
    @NSManaged public func removeFromCdQuestions(_ values: NSSet)

}

extension CDCategory : Identifiable {

}
