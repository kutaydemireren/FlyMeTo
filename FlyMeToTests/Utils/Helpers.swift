//
//  Helpers.swift
//  FlyMeToTests
//
//  Created by Kutay Demireren on 29/04/2024.
//

import Foundation

func loadPlacesJSONData() -> Data {
    let bundle = Bundle(for: PlacesRepositoryImpTests.self)
    guard let filePath = bundle.path(forResource: "places", ofType: "json") else {
        fatalError("places.json not found!")
    }

    let data = try! Data(contentsOf: URL(filePath: filePath))
    return data
}
