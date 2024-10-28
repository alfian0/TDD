//
//  TextFieldModifier.swift
//  TextValidator
//
//  Created by Alfian on 16/10/24.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    let label: String
    let errorMessage: String?

    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if !label.isEmpty {
                Text(label)
                    .font(.subheadline)
            }
            content
            Rectangle()
                .fill((errorMessage != nil) ? .red : .secondary)
                .frame(height: (errorMessage != nil) ? 1 : 0.5)
                .animation(.default, value: errorMessage)
            Text(errorMessage ?? "")
                .font(.caption)
                .frame(height: 14)
                .foregroundColor(.red)
                .animation(.default, value: errorMessage)
        }
    }
}

#Preview {
    TextField("", text: .constant("error"))
        .modifier(TextFieldModifier(label: "Error Sample", errorMessage: "Something went wrong"))
}
