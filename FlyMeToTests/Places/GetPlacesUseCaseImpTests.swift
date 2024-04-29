//
//  GetPlacesUseCaseImpTests.swift
//  FlyMeToTests
//
//  Created by Kutay Demireren on 29/04/2024.
//

import XCTest
@testable import FlyMeTo

final class GetPlacesUseCaseImpTests: XCTestCase {
    var sut: GetPlacesUseCaseImp!
    var mockRepository: MockPlacesRepository!

    override func setUpWithError() throws {
        mockRepository = MockPlacesRepository()
        sut = GetPlacesUseCaseImp(repository: mockRepository)
    }

    override func tearDownWithError() throws {
        mockRepository = nil
        sut = nil
    }

    func test_fetch_whenRepositoryThrowsError_shouldThrowExpectedError() async {
        let expectedError = TestError.notAllowed
        mockRepository.error = expectedError

        do {
            let _ = try await sut.fetch()
            XCTFail("Expected error to be thrown.")
        } catch {
            XCTAssertEqual(error as? TestError, expectedError)
        }
    }

    func test_fetch_whenEmpty_shouldThrowNoResult() async {
        mockRepository.places = []

        do {
            let _ = try await sut.fetch()
            XCTFail("Expected error to be thrown.")
        } catch {
            XCTAssertEqual(error as? PlacesError, .noResult)
        }
    }

    func test_fetch_whenSuccess_shouldUpdateExpectedPlaces() async {
        let expectedPlaces: [Place] = .stub
        mockRepository.places = expectedPlaces

        let resultedPlaces = try! await sut.fetch()

        XCTAssertEqual(resultedPlaces, expectedPlaces)
    }
}
