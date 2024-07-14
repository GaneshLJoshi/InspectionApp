//
//  LoginViewModel.swift
//  InspectionApp
//
//  Created by Ganesh Joshi on 15/07/24.
//

import Foundation

class LoginViewModel {
    
    private let authService: AuthService
    var email: String = ""
    var password: String = ""

    init(authService: AuthService) {
        self.authService = authService
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 4
    }
    
    func register(completion: @escaping (Bool, String?) -> Void) {
        authService.register(email: email, password: password) { success, statusCode in
            DispatchQueue.main.async {
                if success {
                    completion(true, nil)
                } else {
                    var errorMessage: String
                    switch statusCode {
                    case 400:
                        errorMessage = "Bad request. Please check your input."
                    case 401:
                        errorMessage = "User already exists. Please proceed for login or enter new user details"
                    case 404:
                        errorMessage = "Not found. Please check the URL."
                    default:
                        errorMessage = "An unexpected error occurred. Please try again."
                    }
                    completion(false, errorMessage)
                }
            }
        }
    }

    func login(completion: @escaping (Bool, String?) -> Void) {
        authService.login(email: email, password: password) { success, statusCode in
            DispatchQueue.main.async {
                if success {
                    completion(true, nil)
                } else {
                    var errorMessage: String
                    switch statusCode {
                    case 400:
                        errorMessage = "Bad request. Please check your input."
                    case 401:
                        errorMessage = "Unauthorized. Please check your credentials."
                    case 404:
                        errorMessage = "Not found. Please check the URL."
                    default:
                        errorMessage = "An unexpected error occurred. Please try again."
                    }
                    completion(false, errorMessage)
                }
            }
        }
    }
}
