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
        ZStack {
            backgroundView

            PlacesList(places: $viewModel.places)
                .scrollContentBackground(.hidden)
        }
    }

    private var backgroundView: some View {
        Rectangle()
            .fill(Color(red: 49/255, green: 144/255, blue: 130/255, opacity: 1.0))
            .ignoresSafeArea()
    }
}

#Preview("Places") {
    PlacesView(viewModel: PlacesViewModel(places: .stub))
}

