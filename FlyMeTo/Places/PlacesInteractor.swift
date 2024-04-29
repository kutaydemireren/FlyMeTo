//
//  Interactor.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 27/04/2024.
//

import Foundation

protocol PlacesInteractor: AnyObject {
    var presenter: PlacesPresenter? { get set }

    /// Tries to fetch and present an ordered list of `Place`s, ow/ presents failure
    func fetchPlaces() async
    /// Redirects user to the `location` of `Place` using the preferred `Redirection.Destination`.
    func select(place: Place) async
}

final class PlacesInteractorImp: PlacesInteractor {
    let repository: PlacesRepository
    let preferredDestinationUseCase: PreferredDestinationUseCase

    weak var presenter: PlacesPresenter?

    init(
        repository: PlacesRepository = PlacesRepositoryTemp(),
        preferredDestinationUseCase: PreferredDestinationUseCase = PreferredDestinationUseCaseImp()
    ) {
        self.repository = repository
        self.preferredDestinationUseCase = preferredDestinationUseCase
    }

    func fetchPlaces() async {
        do {
            let places = try await repository.fetchPlaces()
            guard !places.isEmpty else {
                await presenter?.failure(error: PlacesError.noResult)
                return
            }
            await presenter?.update(places: places)
        } catch {
            await presenter?.failure(error: .underlying(error))
        }
    }

    func select(place: Place) async {
        let preferredDestination = preferredDestinationUseCase.get()
        var components = URLComponents(string: "\(preferredDestination.rawValue)")

        components?.query = "loc=\(place.location.lat),\(place.location.long)"

        await presenter?.redirect(
            Redirection(
                url: components?.url
            )
        )
    }
}
