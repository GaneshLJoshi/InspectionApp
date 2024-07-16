//
//  Service.swift
//  InspectionApp
//
//  Created by Ganesh Joshi on 11/07/24.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
    
    func performRequest(urlString: String, method: String, body: [String: Any]? = nil, completion: @escaping (Bool, Int?, Data?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(false, nil, nil)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                completion(httpResponse.statusCode == 200, httpResponse.statusCode, data)
            } else {
                completion(false, nil, nil)
            }
        }
        
        task.resume()
    }
}

class AuthService {
    
    func register(email: String, password: String, completion: @escaping (Bool, Int?) -> Void) {
        let urlString = "http://localhost:5001/api/register"
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        NetworkService.shared.performRequest(urlString: urlString, method: "POST", body: body) { success, statusCode, _ in
            completion(success, statusCode)
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Bool, Int?) -> Void) {
        let urlString = "http://localhost:5001/api/login"
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        NetworkService.shared.performRequest(urlString: urlString, method: "POST", body: body) { success, statusCode, _ in
            completion(success, statusCode)
        }
    }
}

class InspectionService {
    
    func startInspection(user: CDUser, completion: @escaping (Bool) -> Void) {
        let urlString = "http://localhost:5001/api/inspections/start"
        
        NetworkService.shared.performRequest(urlString: urlString, method: "GET") { success, statusCode, data in
            guard success, statusCode == 200, let data = data else {
                completion(false)
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                PersistenceManager.shared.saveInspection(from: json, user: user)
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    func submitInspection(inspection: CDInspection, completion: @escaping (Int) -> Void) {
        guard let inspectionJSON = generateInspectionJSON(inspection: inspection) else {
            completion(500)
            return
        }
        
        let urlString = "http://localhost:5001/api/inspections/submit"
        NetworkService.shared.performRequest(urlString: urlString, method: "POST", body: inspectionJSON) { success, statusCode, _ in
            completion(statusCode ?? 500)
        }
    }
    
    func generateInspectionJSON(inspection: CDInspection) -> [String: Any]? {
        
        let inspectionId = inspection.id
        let area = inspection.cdArea
        let survey = inspection.cdSurvey
        let categories = survey?.cdCategory?.allObjects as! [CDCategory]
        
        var categoriesArray: [[String: Any]] = []
        
        for category in categories {
            var questionsArray: [[String: Any]] = []
            
            if let questions = category.cdQuestions as? Set<CDQuestion> {
                for question in questions {
                    var answerChoicesArray: [[String: Any]] = []
                    
                    if let answerChoices = question.cdanswerChoices as? Set<CDAnswerChoice> {
                        for answerChoice in answerChoices {
                            let answerChoiceDict: [String: Any] = [
                                "id": answerChoice.id,
                                "name": answerChoice.name ?? "",
                                "score": answerChoice.score
                            ]
                            answerChoicesArray.append(answerChoiceDict)
                        }
                    }
                    
                    let questionDict: [String: Any] = [
                        "id": question.id,
                        "name": question.name ?? "",
                        "selectedAnswerChoiceId": question.selectedAnswerChoiceId,
                        "answerChoices": answerChoicesArray
                    ]
                    questionsArray.append(questionDict)
                }
            }
            
            let categoryDict: [String: Any] = [
                "id": category.id,
                "name": category.name ?? "",
                "questions": questionsArray
            ]
            categoriesArray.append(categoryDict)
        }
        
        let inspectionDict: [String: Any] = [
            "id": inspectionId,
            "area": [
                "id": area?.id as Any,
                "name": area?.name ?? ""
            ],
            "inspectionType": [
                "id": inspection.cdInspectionType?.id as Any,
                "name": inspection.cdInspectionType?.name ?? "",
                "access": inspection.cdInspectionType?.access ?? ""
            ],
            "survey": [
                "id": survey?.id as Any,
                "categories": categoriesArray
            ]
        ]
        
        return ["inspection": inspectionDict]
    }
}





