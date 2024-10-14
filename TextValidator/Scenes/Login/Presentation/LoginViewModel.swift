//
//  LoginViewModel.swift
//  TextValidator
//
//  Created by Alfian on 14/10/24.
//

import Combine
import SwiftUI

final class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var usernameError: String?
    @Published var isEmailValid: Bool = false

    private let didDismiss: () -> Void
    private let emailValidationUsecase: EmailValidationUsecase
    private let coordinator: LoginViewCoordinator

    private var cancellables = Set<AnyCancellable>()

    init(
        emailValidationUsecase: EmailValidationUsecase,
        coordinator: LoginViewCoordinator,
        didDismiss: @escaping () -> Void
    ) {
        self.emailValidationUsecase = emailValidationUsecase
        self.coordinator = coordinator
        self.didDismiss = didDismiss

        $username
            .map(emailValidationUsecase.execute)
            .map { $0 == nil }
            .assign(to: &$isEmailValid)
    }

    func dismiss() {
        didDismiss()
    }
}
