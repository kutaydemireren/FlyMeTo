//
//  PlacesView.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 27/04/2024.
//

import SwiftUI

@MainActor
final class PlacesViewModel: ObservableObject, PlacesPresenter {
    @Published var places: [Place]
    @Published var errorAlertPresented: Bool = false
    var error: PlacesError?

    let interactor: PlacesInteractor

    init(
        places: [Place] = [],
        interactor: PlacesInteractor = PlacesInteractorImp()
    ) {
        self.places = places
        self.interactor = interactor
        self.interactor.presenter = self
        refreshPlaces()
    }

    func refreshPlaces() {
        Task {
            await interactor.fetchPlaces()
        }
    }

    func select(place: Place) {
        Task {
            await interactor.select(place: place)
        }
    }

    func update(places: [Place]) async {
        self.places = places
    }

    func failure(error: PlacesError) async {
        self.error = error
        errorAlertPresented = true
    }

    func redirect(_ redirection: Redirection) async {
        guard let url = redirection.url else { return }
        await UIApplication.shared.open(url)
    }
}

struct PlacesView: View {
    @StateObject var viewModel = PlacesViewModel()

    var body: some View {
        ZStack {
            backgroundView

            PlacesList(
                places: $viewModel.places,
                onTap: { viewModel.select(place:$0) }
            )
            .scrollContentBackground(.hidden)
        }
        .alert(isPresented: $viewModel.errorAlertPresented, error: viewModel.error) {
            Button("Retry") {
                viewModel.refreshPlaces()
            }
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

