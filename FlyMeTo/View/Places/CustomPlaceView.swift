//
//  CustomPlaceView.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 29/04/2024.
//

import SwiftUI

/// Prompts for a latitude and a longitude necessary to create a `Place`.
struct CustomPlaceView: View {
    var title: String = ""
    @Binding var latitude: String
    @Binding var longitude: String

    var body: some View {
        VStack {
            Text(title)
                .font(.callout)

            VStack {
                TitledTextField(
                    title: "Latitude",
                    text: $latitude
                )

                TitledTextField(
                    title: "Longitude",
                    text: $longitude
                )
            }

            Button("Fly me!") {
                // TODO: send?
            }
        }
        .frame(maxWidth: .infinity)
        .listRowBackground(Color.clear)
    }
}

#Preview {
    CustomPlaceView(latitude: .constant("lat"), longitude: .constant("long"))
}
