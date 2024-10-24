//
//  PasswordView.swift
//  TextValidator
//
//  Created by Alfian on 08/10/24.
//

import SwiftUI

struct PasswordView: View {
    @StateObject var viewModel: PasswordViewModel

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Set password")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)

                Text("Set up your password for login")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)

            VStack(spacing: 0) {
                SecureField("Password", text: $viewModel.password)
                    .autocapitalization(.none)
                    .modifier(TextFieldModifier(label: "Password", errorMessage: viewModel.passwordError))

                SecureField("Repeat Password", text: $viewModel.repeatPassword)
                    .autocapitalization(.none)
                    .modifier(TextFieldModifier(label: "Repeat Password", errorMessage: viewModel.repeatPasswordError))

                HStack(spacing: 4) {
                    ForEach(PasswordStrength.allCases, id: \.self) { value in
                        Color("D5D5D6")
                            .overlay {
                                viewModel.passwordStrength.color.opacity(value.rawValue <= viewModel.passwordStrength.rawValue ? 1 : 0)
                                    .animation(.easeInOut, value: viewModel.passwordStrength)
                            }
                    }
                }
                .frame(height: 4)
            }
            .padding()

            Spacer()

            Button {
                Task {
                    await viewModel.didTapCountinue()
                }
            } label: {
                Text("Continue")
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
            .disabled(!viewModel.canSubmit)
            .buttonStyle(LoadingButtonStyle(isLoading: false))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.bottom)
    }
}

#Preview {
    let coordinator = PasswordCoordinator()

    NavigationControllerWrapper(coordinator: coordinator)
        .edgesIgnoringSafeArea(.all)
        .onViewDidLoad {
            coordinator.start()
        }
}
