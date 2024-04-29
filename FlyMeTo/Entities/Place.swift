//
//  Place.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 27/04/2024.
//

import Foundation

struct Place: Equatable, Identifiable, Codable {
    enum CodingKeys: CodingKey {
        case name
        case lat
        case long
    }

    var representable: String {
        return "\(name)-\(location.lat)-\(location.long)"
    }

    let id = UUID()
    let name: String
    let location: PlaceLocation

    init(name: String, location: PlaceLocation) {
        self.name = name
        self.location = location
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let lat = try container.decode(Double.self, forKey: .lat)
        let long = try container.decode(Double.self, forKey: .long)
        self.init(name: name, location: PlaceLocation(lat: lat, long: long))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(location.lat, forKey: .lat)
        try container.encode(location.long, forKey: .long)
    }
}

//

struct PlaceLocation: Equatable {
    let lat: Double
    let long: Double
}

//

struct Redirection {
    enum Destination: String {
        case wikiPlaces = "wikipedia://places"
    }

    let url: URL?
}
