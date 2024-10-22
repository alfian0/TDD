//
//  EmailView.swift
//  TextValidator
//
//  Created by Alfian on 03/10/24.
//

import SwiftUI
import Swinject

class EmailViewAssembly: Assembly {
    func assemble(container: Container) {
        container.register(EmailView.self) { (r, v: EmailViewState, c: EmailCoordinator) in
            guard let viewModel = r.resolve(EmailViewModel.self, arguments: v, c) else {
                fatalError()
            }
            return EmailView(viewModel: viewModel)
        }
    }
}

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
                    Task {
                        await viewModel.didTapCountinue()
                    }
                } label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                }
                .disabled(!viewModel.canSubmit)
                .buttonStyle(LoadingButtonStyle(isLoading: false))

                Button {} label: {
                    Text("Skip")
                }
            }
            .padding(.horizontal)
            .safeAreaBottomPadding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {} label: {
                    Image(systemName: "questionmark.circle")
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.verification()
            }
        }
    }
}

#Preview {
    let coordinator = EmailCoordinatorImpl()

    NavigationControllerWrapper(coordinator: coordinator)
        .edgesIgnoringSafeArea(.all)
        .onViewDidLoad {
            coordinator.start(viewState: .formInput)
        }
}
