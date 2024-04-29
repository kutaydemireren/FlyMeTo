//
//  Interactor.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 27/04/2024.
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

//

enum PlacesError: LocalizedError, Equatable {
    case unknown
    case underlying(Error)
    case noResult

    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Something went wrong!"
        case .underlying(let error):
            return error.localizedDescription
        case .noResult:
            return "No results have been found."
        }
    }

    var failureReason: String? {
        switch self {
        case .unknown:
            return "Failure reason is unknown."
        case .underlying(let error):
            return (error as? LocalizedError)?.failureReason
        case .noResult:
            return "Received an empty result."
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .unknown:
            return "Please try again."
        case .underlying(let error):
            return (error as? LocalizedError)?.recoverySuggestion
        case .noResult:
            return "Please make sure places are remotely available and retry again."
        }
    }

    static func == (lhs: PlacesError, rhs: PlacesError) -> Bool {
        return (lhs as NSError) == (rhs as NSError)
    }
}

//

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

protocol PreferredDestinationUseCase {
    /// Returns the preferred destination.
    ///
    /// Until the app has a second `Redirection.Destination`, it is always assumed to be `wikiPlaces`.
    func get() -> Redirection.Destination
}

struct PreferredDestinationUseCaseImp: PreferredDestinationUseCase {
    func get() -> Redirection.Destination {
        return .wikiPlaces
    }
}
