//
//  PlacesView.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 27/04/2024.
//

import SwiftUI

final class PlacesViewModel: ObservableObject {
    @Published var places: [Place] = .stub
}

struct PlacesView: View {
    @StateObject var viewModel = PlacesViewModel()

    var body: some View {
        PlacesList(places: $viewModel.places)
    }
}

#Preview("Places") {
    PlacesView()
}

