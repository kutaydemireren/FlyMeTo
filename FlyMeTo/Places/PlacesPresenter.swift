//
//  Presenter.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 27/04/2024.
//

import Foundation

protocol PlacesPresenter: AnyObject {
    func failure(error: PlacesError) async
    func update(places: [Place]) async
    func redirect(_ redirection: Redirection) async
}
