//
//  LoginView.swift
//  TextValidator
//
//  Created by Alfian on 03/10/24.
//

import SwiftUI
import Swinject

class LoginViewAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LoginView.self) { (r, c: LoginViewCoordinator, d: @escaping (() -> Void)) in
            guard let viewModel = r.resolve(LoginViewModel.self, arguments: c, d) else {
                fatalError()
            }
            return LoginView(viewModel: viewModel)
        }
    }
}

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
        AppAssembler.shared.resolver.resolve(LoginView.self, arguments: {}, LoginViewCoordinator())
    }
}
