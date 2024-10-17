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
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(LoadingButtonStyle(isLoading: false))
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    EmailVerificationView(
        viewModel: EmailViewFactory().createEmailViewModel(
            viewState: .formInput,
            coordinator: EmailCoordinatorImpl()
        )
    )
}
