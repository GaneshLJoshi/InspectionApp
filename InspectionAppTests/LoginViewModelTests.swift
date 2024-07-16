//
//  LoginViewModelTests.swift
//  InspectionAppTests
//
//  Created by Ganesh Joshi on 16/07/24.
//

import XCTest
@testable import InspectionApp

class LoginViewModelTests: XCTestCase {
    
    var viewModel: LoginViewModel!
    var mockAuthService: MockAuthService!
    
    override func setUp() {
        super.setUp()
        mockAuthService = MockAuthService()
        viewModel = LoginViewModel(authService: mockAuthService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockAuthService = nil
        super.tearDown()
    }
    
    func testIsValidEmail() {
        XCTAssertTrue(viewModel.isValidEmail("test@example.com"))
        XCTAssertFalse(viewModel.isValidEmail("invalid-email"))
    }
    
    func testIsValidPassword() {
        XCTAssertTrue(viewModel.isValidPassword("1234"))
        XCTAssertFalse(viewModel.isValidPassword("123"))
    }
    
    func testRegisterSuccess() {
        viewModel.email = "test@example.com"
        viewModel.password = "1234"
        
        let expectation = self.expectation(description: "Registration succeeded")
        
        mockAuthService.shouldSucceed = true
        
        viewModel.register { success, errorMessage in
            XCTAssertTrue(success)
            XCTAssertNil(errorMessage)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testRegisterFailure() {
        viewModel.email = "test@example.com"
        viewModel.password = "1234"
        
        let expectation = self.expectation(description: "Registration failed")
        
        mockAuthService.shouldSucceed = false
        mockAuthService.statusCode = 400
        
        viewModel.register { success, errorMessage in
            XCTAssertFalse(success)
            XCTAssertEqual(errorMessage, "Bad request. Please check your input.")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testLoginSuccess() {
        viewModel.email = "test@example.com"
        viewModel.password = "1234"
        
        let expectation = self.expectation(description: "Login succeeded")
        
        mockAuthService.shouldSucceed = true
        
        viewModel.login { success, errorMessage in
            XCTAssertTrue(success)
            XCTAssertNil(errorMessage)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testLoginFailure() {
        viewModel.email = "test@example.com"
        viewModel.password = "1234"
        
        let expectation = self.expectation(description: "Login failed")
        
        mockAuthService.shouldSucceed = false
        mockAuthService.statusCode = 401
        
        viewModel.login { success, errorMessage in
            XCTAssertFalse(success)
            XCTAssertEqual(errorMessage, "Unauthorized. Please check your credentials.")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

class MockAuthService: AuthService {
    
    var shouldSucceed: Bool = true
    var statusCode: Int? = 200
    
    override func register(email: String, password: String, completion: @escaping (Bool, Int?) -> Void) {
        completion(shouldSucceed, shouldSucceed ? 200 : statusCode)
    }
    
    override func login(email: String, password: String, completion: @escaping (Bool, Int?) -> Void) {
        completion(shouldSucceed, shouldSucceed ? 200 : statusCode)
    }
}
