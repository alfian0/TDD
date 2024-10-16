//
//  EmailFormView.swift
//  TextValidator
//
//  Created by Alfian on 15/10/24.
//

import SwiftUI

struct EmailFormView: View {
    @StateObject var viewModel: EmailViewModel

    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Add your email")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)

                Text("Please input your personal email address to receive any notificatio")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 8) {
                Text("Email")
                    .font(.subheadline)
                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                Divider()
                Text(viewModel.emailError ?? "")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            .padding(.horizontal)

            Spacer()

            VStack {
                Button {
                    Task {
                        await viewModel.didTapCountinue()
                    }
                } label: {
                    Text("Continue")
                        .frame(minHeight: 24)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(viewModel.canSubmit ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(!viewModel.canSubmit)

                Button {} label: {
                    Text("Skip")
                }
            }
            .padding(.horizontal)
            .safeAreaBottomPadding()
        }
    }
}

#Preview {
    EmailFormView(viewModel: EmailViewModel(
        viewState: .formInput,
        emailValidationUsecase: EmailValidationUsecase(),
        registerEmailUsecase: RegisterEmailUsecase(
            repository: RegisterEmailRepository(service: FirebaseAuthService()),
            emailValidationUsecase: EmailValidationUsecase()
        ),
        reloadUserUsecase: ReloadUserUsecase(
            repository: RegisterEmailRepository(service: FirebaseAuthService())
        ),
        coordinator: EmailCoordinatorImpl()
    ))
}
