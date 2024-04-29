//
//  PlacesList.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 27/04/2024.
//

import SwiftUI

struct PlacesList<Supplement: View>: View {
    @Binding var places: [Place]
    @ViewBuilder var supplement: Supplement

    var onTap: ((Place) -> Void)?

    init(
        places: Binding<[Place]>,
        @ViewBuilder supplement: () -> Supplement = { EmptyView() },
        onTap: ((Place) -> Void)? = nil
    ) {
        self._places = places
        self.supplement = supplement()
        self.onTap = onTap
    }

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
            
            supplement
        }
        .listRowSpacing(16)
    }
}

#Preview("Places List") {
    PlacesList(places: .constant(.stub))
        .scrollContentBackground(.hidden)
        .background {
            Color(red: 49/255, green: 144/255, blue: 130/255, opacity: 1.0)
        }
}


//latitude: .constant("12.34"), longitude: .constant("-83.23")
