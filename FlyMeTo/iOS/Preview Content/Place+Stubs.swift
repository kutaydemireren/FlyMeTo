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
            location: PlaceLocation(
                lat: 35.011665,
                long: 135.768326
            )
        )
    }

    static var chicago: Self {
        return Place(
            name: "Chicago",
            location: PlaceLocation(
                lat: 41.881832,
                long: -87.623177
            )
        )
    }

    static var istanbul: Self {
        return Place(
            name: "Istanbul",
            location: PlaceLocation(
                lat: 41.015137,
                long: 28.979530
            )
        )
    }
}

extension Array where Element == Place {
    static var stub: Self {
        return [.kyoto, .chicago, .istanbul]
    }
}
