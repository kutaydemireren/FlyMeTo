//
//  PlacesList.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 27/04/2024.
//

import SwiftUI

struct PlacesList: View {
    @Binding var places: [Place]

    var body: some View {
        List {
            ForEach(places) { place in
                VStack(alignment: .leading) {
                    Text(place.name)
                        .font(.footnote)
                        .bold()
                    Text("Latitude: \(place.lat)")
                        .font(.caption)
                    Text("Longitude: \(place.long)")
                        .font(.caption)
                }
                .listRowBackground(Color(red: 230/255.0, green: 170/255.0, blue: 39/255.0, opacity: 0.6))
            }
        }
        .listRowSpacing(16)
    }
}

#Preview("Places List") {
    PlacesList(places: .constant(.stub))
}
