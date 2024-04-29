//
//  PreferredDestinationUseCase.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 29/04/2024.
//

import Foundation

protocol PreferredDestinationUseCase {
    /// Returns the preferred destination.
    ///
    /// Until the app has a second `Redirection.Destination`, it is always assumed to be `wikiPlaces`.
    func get() -> Redirection.Destination
}

struct PreferredDestinationUseCaseImp: PreferredDestinationUseCase {
    func get() -> Redirection.Destination {
        return .wikiPlaces
    }
}
