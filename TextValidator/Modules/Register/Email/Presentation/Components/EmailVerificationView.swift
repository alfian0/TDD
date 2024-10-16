//
//  EmailVerificationView.swift
//  TextValidator
//
//  Created by Alfian on 14/10/24.
//

import SwiftUI

struct EmailVerificationView: View {
    @StateObject var viewModel: EmailViewModel

    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Verify your email address")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)

                Text("We have just send email verification link on your email. Please check email and click on that link to verify your email address.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "envelope")
                    Text(viewModel.email)
                        .font(.body.bold())
                    Button {
                        Task {
                            await viewModel.reload()
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }

                Spacer()

                Button {
                    Task {
                        await viewModel.didTapCountinue()
                    }
                } label: {
                    Text("Reload")
                        .frame(minHeight: 24)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    EmailVerificationView(
        viewModel: EmailViewModel(
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
        )
    )
}
