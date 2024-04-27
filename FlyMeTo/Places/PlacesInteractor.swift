//
//  Interactor.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 27/04/2024.
//

import Foundation

enum PlacesError: Error {
    case noResult
}

protocol PlacesInteractor {
    /// Tries to fetch and present an ordered list of `Place`s, ow/ presents failure
    func fetchPlaces() async
}

struct PlacesInteractorImp: PlacesInteractor {
    let repository: PlacesRepository

    weak var placesPresenter: PlacesPresenter?

    func fetchPlaces() async {
        do {
            let places = try await repository.fetchPlaces()
            guard !places.isEmpty else {
                placesPresenter?.failure(error: PlacesError.noResult)
                return
            }
            placesPresenter?.update(places: places)
        } catch {
            placesPresenter?.failure(error: error)
        }
    }
}
