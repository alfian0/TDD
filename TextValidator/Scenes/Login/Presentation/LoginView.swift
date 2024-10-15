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
                Text("Hi, Welcome Back!")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)

                Text("It's good to see you again")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.subheadline)
                    TextField("Email", text: $viewModel.username)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    Divider()
                    Text(viewModel.usernameError ?? "")
                        .font(.caption)
                        .foregroundColor(.red)
                }

                if viewModel.isEmailValid {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.subheadline)
                        TextField("Password", text: .constant(""))
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        Divider()
                        Text("")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }

                HStack(spacing: 4) {
                    Text("Forgot you password?")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Button {} label: {
                        Text("Click here")
                            .font(.subheadline)
                    }
                }
            }
            .padding(.horizontal)

            Spacer()

            Button(action: {}) {
                Text("Continue")
                    .frame(minHeight: 24)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
        }
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
        LoginView(viewModel: LoginViewModel(
            emailValidationUsecase: EmailValidationUsecase(),
            coordinator: LoginViewCoordinator(),
            didDismiss: {}
        )
        )
    }
}
