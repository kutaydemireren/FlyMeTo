//
//  MockNetworkManager.swift
//  FlyMeToTests
//
//  Created by Kutay Demireren on 29/04/2024.
//

import Foundation
@testable import FlyMeTo

final class MockNetworkManager: NetworkManager {
    var error: Error?
    var data: Data = Data()

    func perform(_ request: Request) async throws -> Data {
        return try throwError(error, orReturnValue: data)
    }
}
