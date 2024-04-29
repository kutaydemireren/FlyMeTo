//
//  CustomPlaceView.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 29/04/2024.
//

import SwiftUI

extension Color {
    static var foregroundPrimary: Color {
        Color(red: 230/255.0, green: 170/255.0, blue: 39/255.0, opacity: 0.6)
    }
}

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

            Button {
                // TODO: send?
            } label: {
                Text("Confirm Take Off")
                    .foregroundStyle(.black)
                    .font(.callout)
            }
            .padding(12)
            .background(Color.foregroundPrimary, in: .capsule)
        }
        .frame(maxWidth: .infinity)
        .listRowBackground(Color.clear)
    }
}

#Preview {
    CustomPlaceView(latitude: .constant("lat"), longitude: .constant("long"))
}
