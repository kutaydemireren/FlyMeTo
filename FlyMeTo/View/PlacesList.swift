//
//  PlacesList.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 27/04/2024.
//

import SwiftUI

struct CustomPlaceView: View {
    @Binding var latitude: String
    @Binding var longitude: String

    var body: some View {
        VStack {
            Text("Or, you can try flying yourself:")
                .font(.callout)

            VStack {
                HStack {
                    Text("Latitude")
                        .font(.callout)
                        .lineLimit(1)
                        .frame(width: 100)

                    TextField("", text: $latitude)
                        .multilineTextAlignment(.center)
                        .padding(8)
                        .border(Color(red: 230/255.0, green: 170/255.0, blue: 39/255.0, opacity: 0.6))
                }

                HStack {
                    Text("Longitude")
                        .font(.callout)
                        .lineLimit(1)
                        .frame(width: 100)

                    TextField("", text: $longitude)
                        .multilineTextAlignment(.center)
                        .padding(8)
                        .border(Color(red: 230/255.0, green: 170/255.0, blue: 39/255.0, opacity: 0.6))
                }
            }

            Button("Fly me!") {
                // TODO: send?
            }
        }
        .frame(maxWidth: .infinity)
        .listRowBackground(Color.clear)
    }
}

struct PlacesList: View {
    @Binding var places: [Place]
    @Binding var latitude: String
    @Binding var longitude: String

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

            CustomPlaceView(
                latitude: $latitude,
                longitude: $longitude
            )
        }
        .listRowSpacing(16)
    }
}

#Preview("Places List") {
    PlacesList(places: .constant(.stub), latitude: .constant("12.34"), longitude: .constant("-83.23"))
        .scrollContentBackground(.hidden)
        .background {
            Color(red: 49/255, green: 144/255, blue: 130/255, opacity: 1.0)
        }
}


//latitude: .constant("12.34"), longitude: .constant("-83.23")
