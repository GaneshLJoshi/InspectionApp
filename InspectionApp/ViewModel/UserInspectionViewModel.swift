//
//  UserInspectionViewModel.swift
//  InspectionApp
//
//  Created by Ganesh Joshi on 11/07/24.
//

import Foundation

class UserInspectionViewModel {
    private let inspectionService: InspectionService
    var user : CDUser!

    init(inspectionService: InspectionService) {
        self.inspectionService = inspectionService
    }

    func startInspection(user: CDUser, completion: @escaping (Bool) -> Void) {

        self.inspectionService.startInspection(user: user) { result in
            completion(result)
        }
    }
}


