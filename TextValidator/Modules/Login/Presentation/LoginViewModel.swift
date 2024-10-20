//
//  LoginViewModel.swift
//  TextValidator
//
//  Created by Alfian on 14/10/24.
//

import Combine
import SwiftUI
import Swinject

@MainActor
class LoginViewModelAssembly: @preconcurrency Assembly {
    func assemble(container: Container) {
        container.register(LoginViewModel.self) { (r, c: LoginViewCoordinator, d: @escaping (() -> Void)) in
            guard let loginUsecase = r.resolve(LoginUsecase.self) else {
                fatalError()
            }
            guard let loginBiometricUsecase = r.resolve(LoginBiometricUsecase.self) else {
                fatalError()
            }
            guard let emailValidationUsecase = r.resolve(EmailValidationUsecase.self) else {
                fatalError()
            }
            return LoginViewModel(
                loginUsecase: loginUsecase,
                loginBiometricUsecase: loginBiometricUsecase,
                emailValidationUsecase: emailValidationUsecase,
                coordinator: c,
                didDismiss: d
            )
        }
    }
}

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var usernameError: String?
    @Published var password: String = ""
    @Published var canSubmit: Bool = false
    @Published var isLoading: Bool = false

    private let loginUsecase: LoginUsecase
    private let loginBiometricUsecase: LoginBiometricUsecase
    private let emailValidationUsecase: EmailValidationUsecase
    private let didDismiss: () -> Void
    private let coordinator: LoginViewCoordinator

    private var cancellables = Set<AnyCancellable>()

    init(
        loginUsecase: LoginUsecase,
        loginBiometricUsecase: LoginBiometricUsecase,
        emailValidationUsecase: EmailValidationUsecase,
        coordinator: LoginViewCoordinator,
        didDismiss: @escaping () -> Void
    ) {
        self.loginUsecase = loginUsecase
        self.loginBiometricUsecase = loginBiometricUsecase
        self.emailValidationUsecase = emailValidationUsecase
        self.coordinator = coordinator
        self.didDismiss = didDismiss

        $username
            .dropFirst()
            .map(emailValidationUsecase.execute)
            .map { $0?.localizedDescription }
            .assign(to: &$usernameError)

        $username
            .dropFirst()
            .map(emailValidationUsecase.execute)
            .map { $0 == nil }
            .assign(to: &$canSubmit)
    }

    func login() async {
        isLoading.toggle()

        defer {
            isLoading.toggle()
        }

        let result = await loginUsecase.exec(email: username, password: password)
        switch result {
        case let .success(user):
            print(user)
        case let .failure(error):
            switch error {
            case let .INVALID_EMAIL(error):
                usernameError = error.localizedDescription
            default: break
            }
        }
    }

    func loginWithBiometric() async {
        isLoading.toggle()

        defer {
            isLoading.toggle()
        }

        let result = await loginBiometricUsecase.exec()
        switch result {
        case let .success(canAuthenticate):
            print(canAuthenticate)
        case let .failure(error):
            print(error)
        }
    }

    func dismiss() {
        didDismiss()
    }
}
