//
//  EmailView.swift
//  TextValidator
//
//  Created by Alfian on 03/10/24.
//

import SwiftUI

struct EmailView: View {
    @StateObject var viewModel: EmailViewModel

    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Add your email")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)

                Text("Please input your personal email address to receive any notification")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)

            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .modifier(TextFieldModifier(label: "Email", errorMessage: viewModel.emailError))
                .padding(.horizontal)

            Spacer()

            VStack {
                Button {
                    viewModel.didTapCountinue()
                } label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                }
                .disabled(!viewModel.canSubmit)
                .buttonStyle(LoadingButtonStyle(isLoading: viewModel.isLoading))

                Button {} label: {
                    Text("Skip")
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {} label: {
                    Image(systemName: "questionmark.circle")
                }
            }
        }
    }
}

#Preview {
    let coordinator = EmailCoordinatorImpl()

    NavigationControllerWrapper(coordinator: coordinator)
        .edgesIgnoringSafeArea(.all)
        .onViewDidLoad {
            coordinator.start()
        }
}
