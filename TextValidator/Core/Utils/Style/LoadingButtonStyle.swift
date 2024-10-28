//
//  LoadingButtonStyle.swift
//  TextValidator
//
//  Created by Alfian on 16/10/24.
//

import SwiftUI

struct LoadingButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    private var isLoading: Bool

    init(isLoading: Bool) {
        self.isLoading = isLoading
    }

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            ActivityIndicatorView(isAnimating: .constant(true), color: .white)
                .opacity(isLoading ? 1 : 0)
            configuration.label
                .font(.headline)
                .opacity(isLoading ? 0 : 1)
        }
        .frame(minHeight: 24)
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(RoundedRectangle(cornerRadius: 8).fill(.blue))
        .foregroundColor(.white)
        .opacity(configuration.isPressed ? 0.2 : 1)
        .opacity(isEnabled ? 1 : 0.6)
        .animation(.default, value: isEnabled)
        .animation(.default, value: isLoading)
    }
}

#Preview {
    Button {} label: {
        Text("Button")
            .frame(maxWidth: .infinity)
    }
    .buttonStyle(LoadingButtonStyle(isLoading: false))
    .disabled(false)
    .padding(.horizontal)
}
