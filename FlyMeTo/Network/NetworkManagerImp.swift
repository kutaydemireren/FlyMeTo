//
//  NetworkManager.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 29/04/2024.
//

import Foundation

extension URLSession {
    /// `URLSession` making sure always the latest content is fetched.
    static let noCache: URLSession = {
        var configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        configuration.urlCache = nil
        return URLSession(configuration: configuration)
    }()
}

private enum HTTPStatusCode: Int {
    case success

    init?(rawValue: Int) {
        switch rawValue {
        case 200..<300:
            self = .success
        default:
            return nil
        }
    }
}

struct NetworkManagerImp: NetworkManager {
    private let urlSession: URLSession

    init(urlSession: URLSession = URLSession.noCache) {
        self.urlSession = urlSession
    }

    func perform(_ request: Request) async throws -> Data {
        let (data, response) = try await urlSession.data(for: request.createURLRequest())

        guard let httpResponse = response as? HTTPURLResponse,
              case .success = HTTPStatusCode(rawValue: httpResponse.statusCode) else {
            throw NetworkError.unexpectedServerResponse
        }

        return data
    }
}
