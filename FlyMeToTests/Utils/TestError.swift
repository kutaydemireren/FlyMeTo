//
//  TestError.swift
//  FlyMeToTests
//
//  Created by Kutay Demireren on 27/04/2024.
//

import Foundation

enum TestError: Error {
    case notAllowed
}

/// Throws error if provided, otherwise returns the value forced unwrapping.
func throwError<T>(_ error: Error?, orReturnValue value: T?) throws -> T {
    if let error { throw error }
    return value!
}
