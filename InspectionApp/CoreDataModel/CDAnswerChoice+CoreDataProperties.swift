//
//  CDAnswerChoice+CoreDataProperties.swift
//  InspectionApp
//
//  Created by Ganesh Joshi on 13/07/24.
//
//

import Foundation
import CoreData


extension CDAnswerChoice {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDAnswerChoice> {
        return NSFetchRequest<CDAnswerChoice>(entityName: "CDAnswerChoice")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var score: Double
    @NSManaged public var cdquesion: CDQuestion?

}

extension CDAnswerChoice : Identifiable {

}
