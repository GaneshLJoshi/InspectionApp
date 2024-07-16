//
//  InspectionAppTests.swift
//  InspectionAppTests
//
//  Created by Ganesh Joshi on 11/07/24.
//

import XCTest
@testable import InspectionApp

class UserInspectionViewModelTests: XCTestCase {
    
    var viewModel: UserInspectionViewModel!
    var mockInspectionService: MockInspectionService!
    
    override func setUp() {
        super.setUp()
        mockInspectionService = MockInspectionService()
        viewModel = UserInspectionViewModel(inspectionService: mockInspectionService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockInspectionService = nil
        super.tearDown()
    }
    
    func testStartInspectionSuccess() {
        let user = CDUser()
        let expectation = self.expectation(description: "Inspection started successfully")
        
        mockInspectionService.shouldSucceed = true
        
        viewModel.startInspection(user: user) { result in
            XCTAssertTrue(result)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testStartInspectionFailure() {
        let user = CDUser()
        let expectation = self.expectation(description: "Inspection failed to start")
        
        mockInspectionService.shouldSucceed = false
        
        viewModel.startInspection(user: user) { result in
            XCTAssertFalse(result)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

class MockInspectionService: InspectionService {
    
    var shouldSucceed: Bool = true
    
    override func startInspection(user: CDUser, completion: @escaping (Bool) -> Void) {
        completion(shouldSucceed)
    }
}

