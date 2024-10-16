//
//  EmailSignInView.swift
//  TextValidator
//
//  Created by Alfian on 15/10/24.
//

import SwiftUI

struct EmailSignInView: View {
    @StateObject var viewModel: LoginViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("Email", text: $viewModel.username)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disabled(viewModel.isLoading)
                .modifier(TextFieldModifier(label: "Email", errorMessage: viewModel.usernameError))

            if viewModel.canSubmit {
                SecureField("Password", text: $viewModel.password)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disabled(viewModel.isLoading)
                    .modifier(TextFieldModifier(label: "Password", errorMessage: nil))
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

        HStack(spacing: 8) {
            Button {
                Task {
                    await viewModel.login()
                }
            } label: {
                Text("Continue")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(LoadingButtonStyle(isLoading: viewModel.isLoading))
            .disabled(!viewModel.canSubmit)

            Button {
                Task {
                    await viewModel.loginWithBiometric()
                }
            } label: {
                Image(systemName: "faceid")
            }
            .buttonStyle(LoadingButtonStyle(isLoading: viewModel.isLoading))
        }
        .padding(.horizontal)
    }
}

#Preview {
    EmailSignInView(viewModel: LoginViewModel(
        loginUsecase: LoginUsecase(
            repository: LoginRepositoryImpl(service: FirebaseAuthService()),
            emailValidationUsecase: EmailValidationUsecase()
        ),
        loginBiometricUsecase: LoginBiometricUsecase(service: BiometricService()),
        emailValidationUsecase: EmailValidationUsecase(),
        coordinator: LoginViewCoordinator(),
        didDismiss: {}
    ))
}
