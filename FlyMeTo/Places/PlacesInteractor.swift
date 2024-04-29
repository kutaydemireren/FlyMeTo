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
    func select(location: PlaceLocation) async
}

final class PlacesInteractorImp: PlacesInteractor {
    var repository: PlacesRepository

    weak var presenter: PlacesPresenter?

    init(
        repository: PlacesRepository = PlacesRepositoryTemp()
    ) {
        self.repository = repository
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

    func select(location: PlaceLocation) async { // TODO: missing implementation
        fatalError("missing implementation")
    }
}
