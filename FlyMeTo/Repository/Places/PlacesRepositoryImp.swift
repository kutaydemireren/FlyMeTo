//
//  PlacesRepositoryImp.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 29/04/2024.
//

import Foundation

// TODO: Move

struct GetPlacesRequest: Request {
    var host: String = "raw.githubusercontent.com"
    var path: String = "/abnamrocoesd/assignment-ios/main/locations.json"
}

struct PlacesResponse: Decodable {
    let locations: [Place]
}

//

struct PlacesRepositoryImp: PlacesRepository {
    private let networkManager: NetworkManager
    private let decoding: Decoding

    init(
        networkManager: NetworkManager = NetworkManagerImp(),
        decoding: Decoding = JSONDecoder()
    ) {
        self.networkManager = networkManager
        self.decoding = decoding
    }

    func fetchPlaces() async throws -> [Place] {
        let data = try await networkManager.perform(GetPlacesRequest())
        let response = try decoding.decode(PlacesResponse.self, from: data)
        return response.locations
    }
}
