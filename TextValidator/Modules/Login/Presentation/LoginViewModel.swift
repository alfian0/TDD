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
    @Published var signInMethod: Int = 0
    @Published var username: String = ""
    @Published var usernameError: String?
    @Published var password: String = ""
    @Published var isEmailValid: Bool = false

    private let loginUsecase: LoginUsecase
    private let emailValidationUsecase: EmailValidationUsecase
    private let didDismiss: () -> Void
    private let coordinator: LoginViewCoordinator

    private var cancellables = Set<AnyCancellable>()

    init(
        loginUsecase: LoginUsecase,
        emailValidationUsecase: EmailValidationUsecase,
        coordinator: LoginViewCoordinator,
        didDismiss: @escaping () -> Void
    ) {
        self.loginUsecase = loginUsecase
        self.emailValidationUsecase = emailValidationUsecase
        self.coordinator = coordinator
        self.didDismiss = didDismiss

        $username
            .map(emailValidationUsecase.execute)
            .map { $0 == nil }
            .assign(to: &$isEmailValid)
    }

    func login() async {
        let result = await loginUsecase.exec(email: username, password: password)
        switch result {
        case let .success(user):
            print(user)
        case let .failure(error):
            print(error)
        }
    }

    func dismiss() {
        didDismiss()
    }
}
