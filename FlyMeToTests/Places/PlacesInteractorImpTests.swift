//
//  PlacesInteractorImpTests.swift
//  FlyMeToTests
//
//  Created by Kutay Demireren on 27/04/2024.
//

import XCTest

struct Place: Equatable {
    let name: String
    let lat: Double
    let long: Double
}

//

extension Place {
    static var kyoto: Self {
        return Place(
            name: "Kyoto",
            lat: 35.011665,
            long: 135.768326
        )
    }

    static var chicago: Self {
        return Place(
            name: "Chicago",
            lat: 41.881832,
            long: -87.623177
        )
    }

    static var istanbul: Self {
        return Place(
            name: "Istanbul",
            lat: 41.015137,
            long: 28.979530
        )
    }
}

extension Array where Element == Place {
    static var stub: Self {
        return [.kyoto, .chicago, .istanbul]
    }
}

//

protocol PlacesRepository {
    func fetchPlaces() async throws -> [Place]
}

//

enum TestError: Error {
    case notAllowed
}

/// Throws error if provided, otherwise returns the value forced unwrapping.
func throwError<T>(_ error: Error?, orReturnValue value: T?) throws -> T {
    if let error { throw error }
    return value!
}

final class MockPlacesRepository: PlacesRepository {
    var error: TestError? = nil
    var places: [Place] = []

    func fetchPlaces() async throws -> [Place] {
        return try throwError(error, orReturnValue: places)
    }
}

//

enum PlacesError: Error {
    case noResult
}

//

protocol PlacesPresenter: AnyObject {
    func failure(error: Error)
    func update(places: [Place])
}

//

final class MockPlacesPresenter: PlacesPresenter {

    var updatedPlaces: [Place] = []
    func update(places: [Place]) {
        updatedPlaces = places
    }

    var failureError: Error?
    func failure(error: Error) {
        failureError = error
    }
}

//

protocol PlacesInteractor {
    /// Returns an ordered list of `Place`s.
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

//

final class PlacesInteractorImpTests: XCTestCase {
    var sut: PlacesInteractorImp!
    var mockRepository: MockPlacesRepository!
    var mockPresenter: MockPlacesPresenter!

    override func setUpWithError() throws {
        mockRepository = MockPlacesRepository()
        mockPresenter = MockPlacesPresenter()
        sut = PlacesInteractorImp(repository: mockRepository, placesPresenter: mockPresenter)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_fetchPlaces_whenRepositoryThrowsError_shouldThrowSameError() async {
        mockRepository.error = .notAllowed

        await sut.fetchPlaces()

        XCTAssertEqual(mockPresenter.failureError as? TestError, .notAllowed)
    }

    func test_fetchPlaces_whenEmpty_shouldThrowNoResult() async {
        mockRepository.places = []

        await sut.fetchPlaces()

        XCTAssertEqual(mockPresenter.failureError as? PlacesError, .noResult)
    }

    func test_fetchPlaces_whenSuccess_shouldReturnExpected() async throws {
        let expectedPlaces: [Place] = .stub
        mockRepository.places = expectedPlaces

        await sut.fetchPlaces()

        XCTAssertEqual(mockPresenter.updatedPlaces, expectedPlaces)
    }
}
