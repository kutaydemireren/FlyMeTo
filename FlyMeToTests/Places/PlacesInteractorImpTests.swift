//
//  PlacesInteractorImpTests.swift
//  FlyMeToTests
//
//  Created by Kutay Demireren on 27/04/2024.
//

import XCTest
@testable import FlyMeTo

final class MockVerifyLocation: VerifyLocationUseCase {
    var error: Error? = nil

    func verify(_ location: PlaceLocation) throws -> Bool {
        return try throwError(error, orReturnValue: true)
    }
}

final class PlacesInteractorImpTests: XCTestCase {
    var sut: PlacesInteractorImp!
    var mockGetPlaces: MockGetPlacesUseCase!
    var mockVerifyLocation: MockVerifyLocation!
    var mockPresenter: MockPlacesPresenter!

    override func setUpWithError() throws {
        mockGetPlaces = MockGetPlacesUseCase()
        mockVerifyLocation = MockVerifyLocation()
        mockPresenter = MockPlacesPresenter()
        sut = PlacesInteractorImp(getPlaces: mockGetPlaces, verifyLocation: mockVerifyLocation)
        sut.presenter = mockPresenter
    }

    override func tearDownWithError() throws {
        mockGetPlaces = nil
        mockVerifyLocation = nil
        mockPresenter = nil
        sut = nil
    }
}

// MARK: fetchPlaces
extension PlacesInteractorImpTests {
    func test_fetchPlaces_whenThrownPlacesError_shouldFailWithExpectedError() async {
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
    func test_selectLocation_whenThrownPlacesError_shouldFailWithExpectedError() async {
        let expectedError = PlacesError.noResult
        mockVerifyLocation.error = expectedError

        await sut.select(place: .chicago)

        XCTAssertEqual(mockPresenter.failureError, expectedError)
    }

    func test_selectLocation_whenThrownAnyError_shouldFailWithUnderlyingError() async {
        let expectedError = TestError.notAllowed
        mockVerifyLocation.error = expectedError

        await sut.select(place: .chicago)

        XCTAssertEqual(mockPresenter.failureError, .underlying(expectedError))
    }

    func test_selectLocation_shouldRedirectWithExpectedQuery() async {
        await sut.select(place: .chicago)

        XCTAssertEqual(mockPresenter.redirection?.url?.absoluteString, "wikipedia://places?loc=\(PlaceLocation.chicago.lat),\(PlaceLocation.chicago.long)")
    }
}
