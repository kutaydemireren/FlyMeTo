//
//  Place+Stubs.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 27/04/2024.
//

import Foundation

extension Place {
    static var kyoto: Self {
        return Place(
            name: "Kyoto",
            location: .kyoto
        )
    }

    static var chicago: Self {
        return Place(
            name: "Chicago",
            location: .chicago
        )
    }

    static var istanbul: Self {
        return Place(
            name: "Istanbul",
            location: .istanbul
        )
    }
}

extension PlaceLocation {
    static var kyoto: Self {
        return PlaceLocation(
            lat: 35.011665,
            long: 135.768326
        )
    }

    static var chicago: Self {
        return PlaceLocation(
            lat: 41.881832,
            long: -87.623177
        )
    }

    static var istanbul: Self {
        return PlaceLocation(
            lat: 41.015137,
            long: 28.979530
        )
    }
}

extension Array where Element == Place {
    static var stub: Self {
        return [.kyoto, .chicago, .istanbul]
    }
}
