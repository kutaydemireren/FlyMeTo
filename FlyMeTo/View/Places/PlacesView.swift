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

    @Published var latitude: String = ""
    @Published var longitude: String = ""

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

    func confirmLocation() {
        guard
            let lat = Double(latitude),
            let long = Double(longitude)
        else { return }

        Task {
            await interactor.select(
                place: Place(name: nil, location: PlaceLocation(lat: lat, long: long))
            )
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

            if viewModel.places.count > 0 {
                resultView
            } else {
                noResultView
            }
        }
        .alert(isPresented: $viewModel.errorAlertPresented, error: viewModel.error) {
            Button("Retry") {
                viewModel.refreshPlaces()
            }
        }
    }

    @ViewBuilder 
    var noResultView: some View {
        EmptyView()
    }

    @ViewBuilder 
    var resultView: some View {
        PlacesList(
            places: $viewModel.places,
            supplement: {
                CustomPlaceView(
                    title: "Or, you can try flying yourself:",
                    latitude: $viewModel.latitude,
                    longitude: $viewModel.longitude,
                    confirm: { viewModel.confirmLocation() }
                )
            },
            onTap: { viewModel.select(place:$0) }
        )
        .scrollContentBackground(.hidden)
    }

    private var backgroundView: some View {
        Rectangle()
            .fill(Color.backgroundPrimary)
            .ignoresSafeArea()
    }
}

#Preview("Places") {
    PlacesView(viewModel: PlacesViewModel(places: .stub))
}

