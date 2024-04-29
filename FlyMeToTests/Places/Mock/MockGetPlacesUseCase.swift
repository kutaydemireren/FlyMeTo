//
//  MockGetPlacesUseCase.swift
//  FlyMeToTests
//
//  Created by Kutay Demireren on 29/04/2024.
//

import Foundation
@testable import FlyMeTo

final class MockGetPlacesUseCase: GetPlacesUseCase {
    var error: Error? = nil
    var places: [Place] = []

    func fetch() async throws -> [Place] {
        return try throwError(error, orReturnValue: places)
    }
}
