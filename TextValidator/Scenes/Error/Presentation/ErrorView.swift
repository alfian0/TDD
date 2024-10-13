//
//  ErrorView.swift
//  TextValidator
//
//  Created by Alfian on 03/10/24.
//

import SwiftUI

struct ErrorView: View {
    let title: String
    let subtitle: String
    let didDismiss: () -> Void

    var body: some View {
        VStack {
            Spacer()
            Text("⛔️")
                .font(.system(size: 50))
            Spacer()
            Text(title)
                .font(.title)
            Text(subtitle)
                .font(.body)
                .foregroundColor(.secondary)
            Spacer()
            Button {
                didDismiss()
            } label: {
                Text("Close")
            }
        }
    }
}

#Preview {
    ErrorView(title: "Error", subtitle: "Something went wrong") {}
}
