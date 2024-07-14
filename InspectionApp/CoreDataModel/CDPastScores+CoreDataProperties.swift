//
//  CDPastScores+CoreDataProperties.swift
//  InspectionApp
//
//  Created by Ganesh Joshi on 13/07/24.
//
//

import Foundation
import CoreData


extension CDPastScores {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDPastScores> {
        return NSFetchRequest<CDPastScores>(entityName: "CDPastScores")
    }

    @NSManaged public var score: Double
    @NSManaged public var user: CDUser?

}

extension CDPastScores : Identifiable {

}
