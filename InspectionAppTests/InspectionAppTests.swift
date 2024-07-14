//
//  InspectionAppTests.swift
//  InspectionAppTests
//
//  Created by Ganesh Joshi on 11/07/24.
//

import XCTest
@testable import InspectionApp

class InspectionAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

//MARK: LoginViewModelTests

class LoginViewModelTests: XCTestCase {
    func testLoginSuccess() {
        let authService = MockAuthService()
        let viewModel = LoginViewModel(authService: authService)
        viewModel.email = "test@test.com"
        viewModel.password = "password"
        
        let expectation = self.expectation(description: "Login successful")
        viewModel.login { success in
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}

class MockAuthService: AuthService {
    override func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        completion(true)
    }
}
