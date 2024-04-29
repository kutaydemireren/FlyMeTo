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
    let getPlaces: GetPlacesUseCase
    let preferredDestination: PreferredDestinationUseCase
    let verifyLocation: VerifyLocationUseCase

    weak var presenter: PlacesPresenter?

    init(
        getPlaces: GetPlacesUseCase = GetPlacesUseCaseImp(),
        preferredDestination: PreferredDestinationUseCase = PreferredDestinationUseCaseImp(),
        verifyLocation: VerifyLocationUseCase = VerifyLocationUseCaseImp()
    ) {
        self.getPlaces = getPlaces
        self.preferredDestination = preferredDestination
        self.verifyLocation = verifyLocation
    }

    func fetchPlaces() async {
        do {
            let places = try await getPlaces.fetch()
            await presenter?.update(places: places)
        } catch {
            await failure(with: error)
        }
    }

    func select(place: Place) async {
        do {
            guard try verifyLocation.verify(place.location) else {
                await failure(with: PlacesError.unknown)
                return
            }

            let preferredDestination = preferredDestination.get()
            let components = createURLComponents(for: place.location, to: preferredDestination)

            await presenter?.redirect(
                Redirection(
                    url: components?.url
                )
            )
        } catch {
            await failure(with: error)
        }
    }

    private func createURLComponents(for location: PlaceLocation, to destination: Redirection.Destination) -> URLComponents? {
        var components = URLComponents(string: "\(destination.rawValue)")
        components?.query = "loc=\(location.lat),\(location.long)"

        return components
    }

    private func failure(with error: Error) async {
        await presenter?.failure(error: (error as? PlacesError) ?? .underlying(error))
    }
}
