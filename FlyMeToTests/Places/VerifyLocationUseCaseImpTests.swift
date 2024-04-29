//
//  VerifyLocationUseCaseImpTests.swift
//  FlyMeToTests
//
//  Created by Kutay Demireren on 29/04/2024.
//

import XCTest
@testable import FlyMeTo

// TODO: move

struct VerifyLocationUseCaseImp {
    func verify(_ location: PlaceLocation) throws {

    }
}

//


extension Double {
    static let invalidLatitude: Self = 181
    static let validLatitude: Self = -180
    static let invalidLongitude: Self = -91
    static let validLongitude: Self = 90
}

//

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
            try sut.verify(location)
            XCTFail("Expected error to be thrown.")
        } catch {
            XCTAssertEqual(error as? PlacesError, .latitudeInvalid(location))
        }
    }

    func test_verify_whenLongitudeInvalid_shouldThrowExpectedError() async {
        let location = PlaceLocation(lat: .invalidLatitude, long: .invalidLongitude)
        do {
            try sut.verify(location)
            XCTFail("Expected error to be thrown.")
        } catch {
            XCTAssertEqual(error as? PlacesError, .longitudeInvalid(location))
        }
    }
}
