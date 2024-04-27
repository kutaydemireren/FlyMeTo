//
//  MockPlacesRepository.swift
//  FlyMeToTests
//
//  Created by Kutay Demireren on 27/04/2024.
//

import Foundation
@testable import FlyMeTo

final class MockPlacesRepository: PlacesRepository {
    var error: TestError? = nil
    var places: [Place] = []

    func fetchPlaces() async throws -> [Place] {
        return try throwError(error, orReturnValue: places)
    }
}
