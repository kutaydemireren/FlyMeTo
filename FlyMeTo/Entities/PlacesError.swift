//
//  PlacesError.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 29/04/2024.
//

import Foundation

enum PlacesError: LocalizedError, Equatable {
    static func == (lhs: PlacesError, rhs: PlacesError) -> Bool {
        return (lhs as NSError) == (rhs as NSError)
    }

    case unknown
    case underlying(Error)
    case noResult
    case latitudeInvalid(PlaceLocation)
    case longitudeInvalid(PlaceLocation)

    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Something went wrong!"
        case .underlying(let error):
            return error.localizedDescription
        case .noResult:
            return "No results have been found."
        case .latitudeInvalid(let location):
            return "Latitude \(location.lat) is invalid."
        case .longitudeInvalid(let location):
            return "Longitude \(location.long) is invalid."
        }
    }

    var failureReason: String? {
        switch self {
        case .unknown:
            return "Failure reason is unknown."
        case .underlying(let error):
            return (error as? LocalizedError)?.failureReason
        case .noResult:
            return "Received an empty result."
        case .latitudeInvalid(let location):
            return "Latitude \(location.lat)-\(location.long) is invalid."
        case .longitudeInvalid(let location):
            return "Longitude \(location.long) is invalid."
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .unknown:
            return "Please try again."
        case .underlying(let error):
            return (error as? LocalizedError)?.recoverySuggestion
        case .noResult:
            return "Please make sure places are remotely available and retry again."
        case .latitudeInvalid:
            return "Please make sure latitude is in range \(Double.lowestPossibleLatitude)-\(Double.highestPossibleLatitude)"
        case .longitudeInvalid:
            return "Please make sure latitude is in range \(Double.lowestPossibleLongitude)-\(Double.highestPossibleLongitude)"
        }
    }
}
