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