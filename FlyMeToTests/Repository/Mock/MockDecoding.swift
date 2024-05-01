//
//  MockDecoding.swift
//  FlyMeToTests
//
//  Created by Kutay Demireren on 29/04/2024.
//

import Foundation
@testable import FlyMeTo

final class MockDecoding: Decoding {
    var data: [Data] = []
    var error: Error?
    var decoded: Decodable?

    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        self.data.append(data)
        return try throwError(error, orReturnValue: decoded as? T)
    }
}
