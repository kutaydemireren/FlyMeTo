//
//  GetPlacesUseCaseImp.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 29/04/2024.
//

import Foundation

protocol GetPlacesUseCase {
    func fetch() async throws -> [Place]
}

struct GetPlacesUseCaseImp: GetPlacesUseCase {
    let repository: PlacesRepository

    init(
        repository: PlacesRepository = PlacesRepositoryTemp()
    ) {
        self.repository = repository
    }

    func fetch() async throws -> [Place] {
        let places = try await repository.fetchPlaces()
        guard !places.isEmpty else {
            throw PlacesError.noResult
        }
        return places
    }
}
