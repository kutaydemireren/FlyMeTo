//
//  View+Keyboard.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 29/04/2024.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
