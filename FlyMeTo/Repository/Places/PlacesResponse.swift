//
//  PlacesResponse.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 29/04/2024.
//

import Foundation

struct PlacesResponse: Decodable {
    let locations: [Place]
}
