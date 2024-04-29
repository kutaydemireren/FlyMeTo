//
//  PlacesList.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 27/04/2024.
//

import SwiftUI

struct PlacesList: View {
    @Binding var places: [Place]

    var onTap: ((Place) -> Void)?

    var body: some View {
        List {
            ForEach(places) { place in
                HStack {
                    VStack(alignment: .leading) {
                        if let name = place.name {
                            Text(name)
                                .font(.footnote)
                                .bold()
                        }
                        Text("Latitude: \(place.location.lat)")
                            .font(.caption)
                        Text("Longitude: \(place.location.long)")
                            .font(.caption)
                    }

                    Spacer()
                }
                .contentShape(Rectangle())
                .listRowBackground(Color(red: 230/255.0, green: 170/255.0, blue: 39/255.0, opacity: 0.6))
                .onTapGesture {
                    onTap?(place)
                }
            }
        }
        .listRowSpacing(16)
    }
}

#Preview("Places List") {
    PlacesList(places: .constant(.stub))
}

