//
//  MockPlacesPresenter.swift
//  FlyMeToTests
//
//  Created by Kutay Demireren on 27/04/2024.
//

import Foundation
@testable import FlyMeTo

final class MockPlacesPresenter: PlacesPresenter {
    var failureError: PlacesError?
    func failure(error: PlacesError) {
        failureError = error
    }

    var updatedPlaces: [Place] = []
    func update(places: [Place]) {
        updatedPlaces = places
    }

    var redirection: Redirection?
    func redirect(_ redirection: Redirection) async {
        self.redirection = redirection
    }
}
