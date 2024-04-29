//
//  PlacesInteractorImpTests.swift
//  FlyMeToTests
//
//  Created by Kutay Demireren on 27/04/2024.
//

import XCTest
@testable import FlyMeTo

// TODO: Move

final class MockGetPlacesUseCase: GetPlacesUseCase {
    var error: Error? = nil
    var places: [Place] = []

    func fetch() async throws -> [Place] {
        return try throwError(error, orReturnValue: places)
    }
}

//

final class PlacesInteractorImpTests: XCTestCase {
    var sut: PlacesInteractorImp!
    var mockGetPlaces: MockGetPlacesUseCase!
    var mockPresenter: MockPlacesPresenter!

    override func setUpWithError() throws {
        mockGetPlaces = MockGetPlacesUseCase()
        mockPresenter = MockPlacesPresenter()
        sut = PlacesInteractorImp(getPlaces: mockGetPlaces)
        sut.presenter = mockPresenter
    }

    override func tearDownWithError() throws {
        sut = nil
    }
}

// MARK: fetchPlaces
extension PlacesInteractorImpTests {
    func test_fetchPlaces_whenThrownPlacesError_shouldFailWithPlacesError() async {
        let expectedError = PlacesError.noResult
        mockGetPlaces.error = expectedError

        await sut.fetchPlaces()

        XCTAssertEqual(mockPresenter.failureError, expectedError)
    }

    func test_fetchPlaces_whenThrownAnyError_shouldFailWithUnderlyingError() async {
        let expectedError = TestError.notAllowed
        mockGetPlaces.error = expectedError

        await sut.fetchPlaces()

        XCTAssertEqual(mockPresenter.failureError, .underlying(expectedError))
    }

    func test_fetchPlaces_whenSuccess_shouldUpdateExpectedPlaces() async {
        let expectedPlaces: [Place] = .stub
        mockGetPlaces.places = expectedPlaces

        await sut.fetchPlaces()

        XCTAssertEqual(mockPresenter.updatedPlaces, expectedPlaces)
    }
}

// MARK: selectLocation
extension PlacesInteractorImpTests {
    func test_selectLocation_shouldRedirectWithExpectedQuery() async {
        await sut.select(place: .chicago)

        XCTAssertEqual(mockPresenter.redirection?.url?.absoluteString, "wikipedia://places?loc=\(PlaceLocation.chicago.lat),\(PlaceLocation.chicago.long)")
    }
}
