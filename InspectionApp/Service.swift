//
//  Service.swift
//  InspectionApp
//
//  Created by Ganesh Joshi on 11/07/24.
//

import Foundation

class AuthService {
    
    func register(email: String, password: String, completion: @escaping (Bool, Int?) -> Void) {
        guard let url = URL(string: "http://localhost:5001/api/register") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(false, nil)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    completion(true, httpResponse.statusCode)
                } else {
                    completion(false, httpResponse.statusCode)
                }
            } else {
                completion(false, nil)
            }
        }
        
        task.resume()
    }
    
    func login(email: String, password: String, completion: @escaping (Bool, Int?) -> Void) {
        guard let url = URL(string: "http://localhost:5001/api/login") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(false, nil)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    completion(true, httpResponse.statusCode)
                } else {
                    completion(false, httpResponse.statusCode)
                }
            } else {
                completion(false, nil)
            }
        }
        
        task.resume()
    }
}

class InspectionService {
    
    func startInspection(user: CDUser, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://localhost:5001/api/inspections/start") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false)
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completion(false)
                return
            }
            
            guard let data = data else {
                completion(false)
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                PersistenceManager.shared.saveInspection(from: json, user: user)
                completion(true)
            }
        }.resume()
    }
}



