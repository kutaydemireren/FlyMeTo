//
//  PlacesInteractorImpTests.swift
//  FlyMeToTests
//
//  Created by Kutay Demireren on 27/04/2024.
//

import XCTest

struct Place {
    let name: String
    let lat: Double
    let long: Double
}

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
}
