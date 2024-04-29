//
//  PlacesRepositoryImpTests.swift
//  FlyMeToTests
//
//  Created by Kutay Demireren on 29/04/2024.
//

import XCTest
@testable import FlyMeTo

final class PlacesRepositoryImpTests: XCTestCase {
    var sut: PlacesRepositoryImp!
    var mockNetworkManager: MockNetworkManager!
    var mockDecoding: MockDecoding!

    override func setUpWithError() throws {
        mockNetworkManager = MockNetworkManager()
        mockDecoding = MockDecoding()
        sut = PlacesRepositoryImp(
            networkManager: mockNetworkManager,
            decoding: mockDecoding
        )
    }

    override func tearDownWithError() throws {
        mockNetworkManager = nil
        mockDecoding = nil
        sut = nil
    }

    func test_fetchPlaces_whenNetworkThrowsError_shouldThrowExpectedError() async {
        let expectedError = TestError.notAllowed
        mockNetworkManager.error = expectedError

        do {
            let _ = try await sut.fetchPlaces()
            XCTFail("Expected error to be thrown.")
        } catch {
            XCTAssertEqual(error as? TestError, expectedError)
        }
    }

    func test_fetchPlaces_whenDecodingThrowsError_shouldThrowExpectedError() async {
        let expectedError = TestError.notAllowed
        mockDecoding.error = expectedError

        do {
            let _ = try await sut.fetchPlaces()
            XCTFail("Expected error to be thrown.")
        } catch {
            XCTAssertEqual(error as? TestError, expectedError)
        }
    }

    func test_fetchPlaces_whenSuccess_shouldReturnExpectedPlaces() async throws {
        let expectedPlaces: [Place] = .stub
        mockNetworkManager.data = loadPlacesJSONData()
        mockDecoding.decoded = PlacesResponse(locations: expectedPlaces)

        let resultedPlaces = try await sut.fetchPlaces()

        XCTAssertEqual(resultedPlaces, expectedPlaces)
    }
}
