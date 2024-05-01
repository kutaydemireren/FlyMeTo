//
//  VerifyLocationUseCaseImp.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 29/04/2024.
//

import Foundation

protocol VerifyLocationUseCase {
    func verify(_ location: PlaceLocation) throws -> Bool
}

struct VerifyLocationUseCaseImp: VerifyLocationUseCase {
    func verify(_ location: PlaceLocation) throws -> Bool {
        let lat = location.lat
        guard .lowestPossibleLatitude <= lat && lat <= .highestPossibleLatitude else {
            throw PlacesError.latitudeInvalid(location)
        }

        let long = location.long
        guard .lowestPossibleLongitude <= long && long <= .highestPossibleLongitude else {
            throw PlacesError.longitudeInvalid(location)
        }

        return true
    }
}
