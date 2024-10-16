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

            Picker("", selection: $viewModel.signInMethod) {
                Text("Email").tag(0)
                Text("Phone").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            switch viewModel.signInMethod {
            case 1:
                PhoneSignInView()
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
        LoginView(viewModel: LoginViewModel(
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
}
