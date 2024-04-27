//
//  MockPlacesPresenter.swift
//  FlyMeToTests
//
//  Created by Kutay Demireren on 27/04/2024.
//

import Foundation
@testable import FlyMeTo

final class MockPlacesPresenter: PlacesPresenter {
    var updatedPlaces: [Place] = []
    func update(places: [Place]) {
        updatedPlaces = places
    }

    var failureError: Error?
    func failure(error: Error) {
        failureError = error
    }
}