//
//  LoginView.swift
//  TextValidator
//
//  Created by Alfian on 03/10/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel

    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Hi, Welcome Back!")
                        .font(.title)
                    Image(systemName: "flame.circle.fill")
                        .font(.title)
                        .foregroundStyle(.orange)
                }

                Text("It's good to see you again")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)

            Picker("", selection: $viewModel.signInMethod) {
                Text("Email").tag(0)
                Text("Phone").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            switch viewModel.signInMethod {
            case 1:
                PhoneSignInView(viewModel: viewModel)
            default:
                EmailSignInView(viewModel: viewModel)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .safeAreaBottomPadding()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {} label: {
                    Image(systemName: "questionmark.circle")
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        LoginView(
            viewModel: LoginFactory().createLoginViewModel(
                didDismiss: {},
                coordinator: LoginViewCoordinator()
            )
        )
    }
}
