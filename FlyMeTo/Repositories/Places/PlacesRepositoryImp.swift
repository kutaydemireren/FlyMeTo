//
//  PlacesRepositoryImp.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 29/04/2024.
//

import Foundation

//

var fetchCount = 0 // TODO: Remove

struct PlacesRepositoryTemp: PlacesRepository {
    func fetchPlaces() async throws -> [Place] {
        try await Task.sleep(nanoseconds: 3 * 1_000_000_000)
        fetchCount += 1
        guard fetchCount % 2 == 0 else  {
            throw PlacesError.noResult
        }
        return .stub
    }
}

