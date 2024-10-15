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
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "envelope")
                Text(viewModel.email)
                    .font(.body.bold())
            }

            Spacer()

            Button {
                viewModel.didTapCountinue()
            } label: {
                Text("Resend")
                    .frame(minHeight: 24)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.horizontal)
    }
}

#Preview {
    EmailVerificationView(
        viewModel: EmailViewModel(
            viewState: .formInput,
            emailValidationUsecase: EmailValidationUsecase(),
            setEmailUsecase: SetEmailUsecase(service: EmailService()),
            coordinator: EmailCoordinator()
        )
    )
}
