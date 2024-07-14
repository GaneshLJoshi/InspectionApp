//
//  PersistenceManager.swift
//  InspectionApp
//
//  Created by Ganesh Joshi on 11/07/24.
//

import Foundation
import CoreData

class PersistenceManager {

    static let shared = PersistenceManager()
    
    private init() {}

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "InspectionApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchOrCreateUser(withEmail email: String, completion: @escaping (CDUser) -> Void) {
            let fetchRequest: NSFetchRequest<CDUser> = CDUser.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "email == %@", email)
            
            do {
                let users = try context.fetch(fetchRequest)
                if let existingUser = users.first {
                    completion(existingUser)
                } else {
                    let newUser = CDUser(context: context)
                    newUser.email = email
                    saveContext()
                    completion(newUser)
                }
            } catch {
                print("Failed to fetch user: \(error)")
                let newUser = CDUser(context: context)
                newUser.email = email
                saveContext()
                completion(newUser)
            }
        }
    
    func saveInspection(from json: [String: Any], user: CDUser) {
            guard let inspectionDict = json["inspection"] as? [String: Any] else { return }
            print("Inspection Response: \(inspectionDict)")
            let inspection = CDInspection(context: context)
            
            if let areaDict = inspectionDict["area"] as? [String: Any] {
                let area = CDArea(context: context)
                area.id = Int32(areaDict["id"] as? Int ?? 0)
                area.name = areaDict["name"] as? String
                inspection.cdArea = area
            }
            
            if let inspectionTypeDict = inspectionDict["inspectionType"] as? [String: Any] {
                let inspectionType = CDInspectionType(context: context)
                inspectionType.id = Int32(inspectionTypeDict["id"] as? Int ?? 0)
                inspectionType.name = inspectionTypeDict["name"] as? String
                inspectionType.access = inspectionTypeDict["access"] as? String
                inspection.cdInspectionType = inspectionType
            }
            
            if let surveyDict = inspectionDict["survey"] as? [String: Any] {
                let survey = CDSurvey(context: context)
                
                if let categoriesArray = surveyDict["categories"] as? [[String: Any]] {
                    for categoryDict in categoriesArray {
                        let category = CDCategory(context: context)
                        category.id = Int32(categoryDict["id"] as? Int ?? 0)
                        category.name = categoryDict["name"] as? String
                        
                        if let questionsArray = categoryDict["questions"] as? [[String: Any]] {
                            for questionDict in questionsArray {
                                let question = CDQuestion(context: context)
                                question.id = Int32(questionDict["id"] as? Int ?? 0)
                                question.name = questionDict["name"] as? String
                                question.selectedAnswerChoiceId = questionDict["selectedAnswerChoiceId"] as? Int32 ?? -1
                                
                                if let answerChoicesArray = questionDict["answerChoices"] as? [[String: Any]] {
                                    for answerChoiceDict in answerChoicesArray {
                                        let answerChoice = CDAnswerChoice(context: context)
                                        answerChoice.id = Int32(answerChoiceDict["id"] as? Int ?? 0)
                                        answerChoice.name = answerChoiceDict["name"] as? String
                                        answerChoice.score = answerChoiceDict["score"] as? Double ?? 0.0
                                        question.addToCdanswerChoices(answerChoice)
                                    }
                                }
                                
                                category.addToCdQuestions(question)
                            }
                        }
                        
                        survey.addToCdCategory(category)
                    }
                }
                
                inspection.cdSurvey = survey
                user.cdInspection = inspection
            }
        saveContext()
        }
    
    func deleteInspection(forEmail user: CDUser) {
            if let inspection = user.cdInspection {
                context.delete(inspection)
                user.cdInspection = nil
                saveContext()
            }
        }
    //TODO:: Implement scheduleInspections()
    /*
    func scheduleInspections() {
        let context = PersistenceManager.shared.context

        // Fetch all areas and inspection types
        let areaFetchRequest: NSFetchRequest<CDArea> = CDArea.fetchRequest()
        let inspectionTypeFetchRequest: NSFetchRequest<CDInspectionType> = CDInspectionType.fetchRequest()
        
        do {
            let areas = try context.fetch(areaFetchRequest)
            let inspectionTypes = try context.fetch(inspectionTypeFetchRequest)
            
            for area in areas {
                for inspectionType in inspectionTypes {
                    //TODO:: Add interval & date in CDInspection. Calculate the next inspection date based on the interval
                    let interval = TimeInterval(inspectionType.interval * 24 * 60 * 60)
                    let nextInspectionDate = Date().addingTimeInterval(interval)
                    
                    let inspection = CDInspection(context: context)
                    inspection.id = Int32(UUID().uuidString.hashValue)
                    inspection.date = nextInspectionDate
                    inspection.cdArea = area
                    inspection.cdInspectionType = inspectionType
                    
                    // Create an empty survey for this inspection
                    let survey = CDSurvey(context: context)
                    survey.id = Int32(UUID().uuidString.hashValue)
                    inspection.cdSurvey = survey
                }
            }
            
            try context.save()
            
        } catch {
            print("Failed to schedule inspections: \(error)")
        }
    }
     */
}

