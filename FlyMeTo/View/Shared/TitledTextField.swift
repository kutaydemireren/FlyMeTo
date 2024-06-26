//
//  TitledTextField.swift
//  FlyMeTo
//
//  Created by Kutay Demireren on 29/04/2024.
//

import SwiftUI

/// Represents a constant title (of type Text) followed by a text field.
struct TitledTextField: View {
    var title: String = ""
    var titleLength: CGFloat = 100
    var borderColor: Color = .foregroundPrimary

    @Binding var text: String

    var body: some View {
        HStack {
            Text(title)
                .keyboardType(.decimalPad)
                .font(.callout)
                .lineLimit(1)
                .frame(width: titleLength)

            TextField("", text: $text)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .padding(8)
                .border(borderColor)
        }
    }
}

#Preview {
    TitledTextField(title: "Title", text: .constant("text"))
}
