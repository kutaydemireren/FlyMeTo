//
//  VerifyLocationUseCaseImpTests.swift
//  FlyMeToTests
//
//  Created by Kutay Demireren on 29/04/2024.
//

import XCTest
@testable import FlyMeTo

final class VerifyLocationUseCaseImpTests: XCTestCase {
    var sut: VerifyLocationUseCaseImp!

    override func setUpWithError() throws {
        sut = VerifyLocationUseCaseImp()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_verify_whenLatitudeInvalid_shouldThrowExpectedError() async {
        let location = PlaceLocation(lat: .invalidLatitude, long: .invalidLongitude)
        do {
            let _ = try sut.verify(location)
            XCTFail("Expected error to be thrown.")
        } catch {
            XCTAssertEqual(error as? PlacesError, .latitudeInvalid(location))
        }
    }

    func test_verify_whenLongitudeInvalid_shouldThrowExpectedError() async {
        let location = PlaceLocation(lat: .validLatitude, long: .invalidLongitude)
        do {
            let _ = try sut.verify(location)
            XCTFail("Expected error to be thrown.")
        } catch {
            XCTAssertEqual(error as? PlacesError, .longitudeInvalid(location))
        }
    }

    func test_verify_whenBothValid_shouldReturnTrue() async {
        let location = PlaceLocation(lat: .validLatitude, long: .validLongitude)

        let resultedBool = try! sut.verify(location)

        XCTAssertTrue(resultedBool)
    }
}
