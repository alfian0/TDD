//
//  ErrorView.swift
//  TextValidator
//
//  Created by Alfian on 03/10/24.
//

import SwiftUI

struct ErrorView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var isLandscape: Bool { verticalSizeClass == .compact }
    var isIphone: Bool { horizontalSizeClass == .compact }

    let title: String
    let subtitle: String
    let didDismiss: () -> Void

    var body: some View {
        SplitView {
            ZStack {
                Color("EFEFF0")
                Image("img_error")
            }
        } rightContent: {
            notCompact
                .padding(.vertical)
        }
    }

    @ViewBuilder var notCompact: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.title)
            Text(subtitle)
                .multilineTextAlignment(.center)
                .font(.body)
                .foregroundColor(.secondary)
            Button {
                didDismiss()
            } label: {
                Text("Close")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.automatic)
        }
        .frame(alignment: .center)
        .padding(.horizontal)
    }
}

#Preview {
    ErrorView(title: "Page Not Found", subtitle: "The page you are looking for might have been removed had its name changed or is temporarily unavailable.") {}
}
