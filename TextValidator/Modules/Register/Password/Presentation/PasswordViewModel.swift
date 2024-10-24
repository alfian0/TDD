//
//  PasswordViewModel.swift
//  TextValidator
//
//  Created by Alfian on 10/10/24.
//

import Combine
import SwiftUI

@MainActor
final class PasswordViewModel: ObservableObject {
    @Published var password: String = ""
    @Published var passwordError: String?
    @Published var repeatPassword: String = ""
    @Published var repeatPasswordError: String?
    @Published var passwordStrength: PasswordStrength = .veryWeak
    @Published var canSubmit: Bool = false

    private(set) var setPasswordUsecase: SetPasswordUsecase
    private(set) var passwordStrengthUsecase: PasswordStrengthUsecase
    private(set) var cancellables = Set<AnyCancellable>()
    private var coordinator: PasswordCoordinator

    init(
        setPasswordUsecase: SetPasswordUsecase,
        passwordStrengthUsecase: PasswordStrengthUsecase,
        coordinator: PasswordCoordinator
    ) {
        self.setPasswordUsecase = setPasswordUsecase
        self.passwordStrengthUsecase = passwordStrengthUsecase
        self.coordinator = coordinator

        $password
            .dropFirst()
            .sink { [weak self] value in
                guard let self = self else { return }
                switch passwordStrengthUsecase.execute(password: value) {
                case let .success(result):
                    passwordStrength = result
                    passwordError = nil
                case let .failure(error):
                    passwordStrength = .veryWeak
                    passwordError = error.localizedDescription
                }
            }
            .store(in: &cancellables)

        Publishers.CombineLatest(
            $password.filter { $0.count >= 8 },
            $repeatPassword.dropFirst().filter { $0.count >= 8 }
        )
        .map { $0 == $1 ? nil : TextValidationError.notEqual.localizedDescription }
        .assign(to: &$repeatPasswordError)

        Publishers.CombineLatest($passwordError, $repeatPasswordError)
            .map { [weak self] passwordError, repeatPasswordError in
                guard let self = self else { return false }
                return passwordError == nil && repeatPasswordError == nil && !self.password.isEmpty && !self.repeatPassword.isEmpty
            }
            .assign(to: \.canSubmit, on: self)
            .store(in: &cancellables)
    }

    func didTapCountinue() async {
        let result = await setPasswordUsecase.execute(password: password)

        switch result {
        case .success:
            coordinator.push(.pin)
        case let .failure(error):
            coordinator.present(.error(title: "Error", subtitle: error.localizedDescription, didDismiss: {}))
        }
    }
}
