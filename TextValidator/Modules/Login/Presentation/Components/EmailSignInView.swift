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
                    SecureField("Password", text: $viewModel.password)
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

        Button {
            Task {
                await viewModel.login()
            }
        } label: {
            Text("Continue")
                .frame(minHeight: 24)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .padding(.horizontal)
    }
}
