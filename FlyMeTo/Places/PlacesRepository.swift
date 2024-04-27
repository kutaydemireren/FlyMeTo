//
//  PlacesRepository.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 27/04/2024.
//

import Foundation

protocol PlacesRepository {
    func fetchPlaces() async throws -> [Place]
}
