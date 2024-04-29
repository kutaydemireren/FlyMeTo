//
//  Request.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 29/04/2024.
//

import Foundation

enum RequestType: String {
    case get = "GET"
}

protocol Request {
    var host: String { get }
    var port: Int? { get }
    var path: String { get }
    var requestType: RequestType { get }
}

extension Request {
    var requestType: RequestType {
        return .get
    }

    func createURLRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "http"
        components.host = host
        components.port = port
        components.path = path

        guard let url = components.url else { throw NetworkError.unexpectedURL }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return urlRequest
    }
}
