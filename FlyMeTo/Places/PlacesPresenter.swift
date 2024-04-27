//
//  Presenter.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 27/04/2024.
//

import Foundation

protocol PlacesPresenter: AnyObject {
    func failure(error: Error)
    func update(places: [Place])
}
