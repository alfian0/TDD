//
//  ContactInfoView.swift
//  TextValidator
//
//  Created by Alfian on 02/10/24.
//

import Combine
import SwiftUI
import Swinject

class ContactInfoViewAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ContactInfoView.self) { (r, c: ContactInfoCoordinatorImpl, d: @escaping (() -> Void)) in
            guard let viewModel = r.resolve(ContactInfoViewModel.self, arguments: c, d) else {
                fatalError()
            }
            return ContactInfoView(viewModel: viewModel)
        }
    }
}

struct ContactInfoView: View {
    @StateObject var viewModel: ContactInfoViewModel

    private var cancellables = Set<AnyCancellable>()

    init(viewModel: ContactInfoViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Create your account")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)

                Text("Tell me more about you")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 8) {
                TextField("Fullname", text: $viewModel.fullname)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .modifier(TextFieldModifier(label: "Fullname", errorMessage: viewModel.fullnameError))

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Button {
                            Task {
                                await viewModel.didTapCountryCode()
                            }
                        } label: {
                            Group {
                                if viewModel.isLoading {
                                    ProgressView()
                                } else {
                                    HStack {
                                        Text(viewModel.countryCode.flag)
                                        Text(viewModel.countryCode.dialCode)
                                            .font(.subheadline)
                                    }
                                }
                            }
                        }

                        TextField("Phone", text: $viewModel.phone)
                            .disabled(viewModel.isLoading)
                            .keyboardType(.phonePad)
                    }
                }
                .modifier(TextFieldModifier(label: "Phone", errorMessage: viewModel.phoneError))

                HStack(spacing: 4) {
                    Text("Already have an account ?")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text("Login")
                        .foregroundColor(.blue)
                        .font(.subheadline)
                        .onTapGesture {
                            viewModel.launchLogin()
                        }
                }
            }
            .padding(.horizontal)

            Spacer()

            VStack {
                Toggle(
                    "By clicking Continue, you have agreed to Terms of Use and Privacy Policy",
                    isOn: $viewModel.isAgreeToTnC
                )
                .font(.footnote)
                .foregroundColor(.secondary)
                .toggleStyle(iOSCheckboxToggleStyle())

                Button(action: {
                    Task {
                        await viewModel.didTapCountinue()
                    }
                }) {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(LoadingButtonStyle(isLoading: viewModel.isLoading))
                .disabled(!viewModel.canSubmit)
            }
            .padding(.horizontal)
        }
        .safeAreaBottomPadding()
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
    let coordinator = ContactInfoCoordinatorImpl()

    NavigationControllerWrapper(coordinator: coordinator)
        .edgesIgnoringSafeArea(.all)
        .onViewDidLoad {
            coordinator.start {}
        }
}
