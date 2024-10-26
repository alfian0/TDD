//
//  LoginViewModel.swift
//  TextValidator
//
//  Created by Alfian on 14/10/24.
//

import Combine
import SwiftUI

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
    private let didFinish: () -> Void
    private let coordinator: LoginViewCoordinator

    private var cancellables = Set<AnyCancellable>()

    init(
        loginUsecase: LoginUsecase,
        loginBiometricUsecase: LoginBiometricUsecase,
        emailValidationUsecase: EmailValidationUsecase,
        coordinator: LoginViewCoordinator,
        didDismiss: @escaping () -> Void,
        didFinish: @escaping () -> Void
    ) {
        self.loginUsecase = loginUsecase
        self.loginBiometricUsecase = loginBiometricUsecase
        self.emailValidationUsecase = emailValidationUsecase
        self.coordinator = coordinator
        self.didDismiss = didDismiss
        self.didFinish = didFinish

        setupValidation()
    }

    private func setupValidation() {
        let validationResultPublisher = $username
            .dropFirst()
            .map(emailValidationUsecase.execute)

        validationResultPublisher
            .map { $0?.localizedDescription }
            .assign(to: &$usernameError)

        validationResultPublisher
            .map { $0 == nil }
            .assign(to: &$canSubmit)
    }

    func login() {
        Task {
            await withLoadingState { [weak self] in
                guard let self = self else { return }
                let result = await loginUsecase.exec(email: username, password: password)
                handleLoginResult(result)
            }
        }
    }

    func loginWithBiometric() {
        Task {
            await withLoadingState { [weak self] in
                guard let self = self else { return }
                let result = await loginBiometricUsecase.exec()
                print(result)
            }
        }
    }

    func dismiss() {
        didDismiss()
    }

    private func handleLoginResult(_ result: Result<UserModel, LoginUsecaseError>) {
        switch result {
        case .success:
            didFinish()
        case let .failure(error):
            handleLoginError(error)
        }
    }

    private func handleLoginError(_ error: LoginUsecaseError) {
        switch error {
        case let .invalidEmail(err):
            usernameError = err.localizedDescription
        default:
            break
        }
    }

    private func withLoadingState<T>(execute: @escaping () async -> T) async -> T {
        isLoading = true
        defer {
            isLoading = false
        }
        return await execute()
    }
}
