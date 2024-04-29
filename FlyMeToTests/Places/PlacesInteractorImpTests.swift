//
//  PlacesInteractorImpTests.swift
//  FlyMeToTests
//
//  Created by Kutay Demireren on 27/04/2024.
//

import XCTest
@testable import FlyMeTo

final class PlacesInteractorImpTests: XCTestCase {
    var sut: PlacesInteractorImp!
    var mockRepository: MockPlacesRepository!
    var mockPresenter: MockPlacesPresenter!

    override func setUpWithError() throws {
        mockRepository = MockPlacesRepository()
        mockPresenter = MockPlacesPresenter()
        sut = PlacesInteractorImp(repository: mockRepository)
        sut.presenter = mockPresenter
    }

    override func tearDownWithError() throws {
        sut = nil
    }
}

// MARK: fetchPlaces
extension PlacesInteractorImpTests {
    func test_fetchPlaces_whenRepositoryThrowsError_shouldFailWithExpectedError() async {
        let expectedError = TestError.notAllowed
        mockRepository.error = expectedError

        await sut.fetchPlaces()

        XCTAssertEqual(mockPresenter.failureError, .underlying(expectedError))
    }

    func test_fetchPlaces_whenEmpty_shouldFailWithNoResult() async {
        mockRepository.places = []

        await sut.fetchPlaces()

        XCTAssertEqual(mockPresenter.failureError, .noResult)
    }

    func test_fetchPlaces_whenSuccess_shouldUpdateExpectedPlaces() async {
        let expectedPlaces: [Place] = .stub
        mockRepository.places = expectedPlaces

        await sut.fetchPlaces()

        XCTAssertEqual(mockPresenter.updatedPlaces, expectedPlaces)
    }
}

// MARK:
extension PlacesInteractorImpTests {
    func test_selectLocation_shouldRedirectWithExpectedQuery() async {
        await sut.select(place: .chicago)

        XCTAssertEqual(mockPresenter.redirection?.url?.absoluteString, "wikipedia://places?loc=\(PlaceLocation.chicago.lat),\(PlaceLocation.chicago.long)")
    }
}
