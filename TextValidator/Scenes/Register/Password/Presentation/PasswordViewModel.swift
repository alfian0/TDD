//
//  PasswordViewModel.swift
//  TextValidator
//
//  Created by Alfian on 10/10/24.
//

import Combine
import SwiftUI

final class PasswordViewModel: ObservableObject {
    @Published var password: String = ""
    @Published var passwordError: String?
    @Published var repeatPassword: String = ""
    @Published var repeatPasswordError: String?
    @Published var passwordStrength: PasswordStrength = .veryWeak

    private(set) var passwordStrengthUsecase = PasswordStrengthUsecase()
    private(set) var cancellables = Set<AnyCancellable>()

    init() {
        $password
            .dropFirst()
            .sink { [weak self] value in
                guard let self = self else { return }
                switch passwordStrengthUsecase.execute(password: value) {
                case let .success(result):
                    passwordStrength = result
                    passwordError = nil
                case let .failure(error):
                    passwordError = error.localizedDescription
                }
            }
            .store(in: &cancellables)

        Publishers.CombineLatest(
            $password.filter { $0.count >= 8 },
            $repeatPassword.dropFirst().filter { $0.count >= 8 }
        )
        .map { $0 == $1 ? nil : TextValidationError.NOT_EQUAL.localizedDescription }
        .assign(to: &$repeatPasswordError)
    }
}
