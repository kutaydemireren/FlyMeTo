//
//  PlacesView.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 27/04/2024.
//

import SwiftUI

final class PlacesViewModel: ObservableObject {
    @Published var places: [Place] = [.chicago]
}

struct PlacesView: View {
    @StateObject var viewModel = PlacesViewModel()

    var body: some View {
        PlaceList(places: $viewModel.places)
    }
}

#Preview("Places") {
    PlacesView()
}

struct PlaceList: View {

    @Binding var places: [Place]

    var body: some View {
        List {
            ForEach(places) { place in
                VStack(alignment: .leading) {
                    Text(place.name)
                        .bold()
                    Text("Latitude: \(place.lat)")
                    Text("Longitude: \(place.long)")
                }
            }
        }
    }
}
