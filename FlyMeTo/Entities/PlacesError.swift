//
//  PlacesError.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 29/04/2024.
//

import Foundation

enum PlacesError: LocalizedError, Equatable {
    case unknown
    case underlying(Error)
    case noResult

    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Something went wrong!"
        case .underlying(let error):
            return error.localizedDescription
        case .noResult:
            return "No results have been found."
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
        }
    }

    static func == (lhs: PlacesError, rhs: PlacesError) -> Bool {
        return (lhs as NSError) == (rhs as NSError)
    }
}
