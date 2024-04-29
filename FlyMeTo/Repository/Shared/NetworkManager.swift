//
//  NetworkManager.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 29/04/2024.
//

import Foundation

protocol NetworkManager {
    func perform(_ request: Request) async throws -> Data
}
