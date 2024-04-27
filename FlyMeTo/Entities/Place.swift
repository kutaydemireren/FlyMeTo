//
//  Place.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 27/04/2024.
//

import Foundation

struct Place: Equatable, Identifiable, Codable {
    let id = UUID()
    let name: String
    let lat: Double
    let long: Double

    enum CodingKeys: CodingKey {
        case name
        case lat
        case long
    }

    var representable: String {
        return "\(name)-\(lat)-\(long)"
    }
}
