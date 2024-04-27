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

protocol PlacesInteractor {
    /// Returns an ordered list of `Place`s.
    func getPlaces() async throws -> [Place]
}

struct PlacesInteractorImp: PlacesInteractor {
    let repository: PlacesRepository

    func getPlaces() async throws -> [Place] {
        let places = try await repository.fetchPlaces()
        guard !places.isEmpty else {
            throw PlacesError.noResult
        }
        return places
    }
}

//

final class PlacesInteractorImpTests: XCTestCase {
    var sut: PlacesInteractorImp!
    var mockPlacesRepository: MockPlacesRepository!

    override func setUpWithError() throws {
        mockPlacesRepository = MockPlacesRepository()
        sut = PlacesInteractorImp(repository: mockPlacesRepository)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_getPlaces_whenFetchThrowsError_shouldThrowError() async {
        mockPlacesRepository.error = .notAllowed

        do {
            let _ = try await sut.getPlaces()
            XCTFail("Expected to thrown an error.")
        } catch {
            XCTAssertEqual(error as? TestError, .notAllowed)
        }
    }

    func test_getPlaces_whenFetchEmpty_shouldThrowNoResult() async {
        mockPlacesRepository.places = []

        do {
            let _ = try await sut.getPlaces()
            XCTFail("Expected to thrown an error.")
        } catch {
            XCTAssertEqual(error as? PlacesError, .noResult)
        }
    }

    func test_getPlaces_whenFetchSuccess_shouldReturnExpected() async throws {
        let expectedPlaces: [Place] = .stub
        mockPlacesRepository.places = expectedPlaces

        let resultedPlaces = try await sut.getPlaces()

        XCTAssertEqual(resultedPlaces, expectedPlaces)
    }
}
