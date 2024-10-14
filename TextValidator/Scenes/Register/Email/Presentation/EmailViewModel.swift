//
//  EmailViewModel.swift
//  TextValidator
//
//  Created by Alfian on 14/10/24.
//

import Combine
import SwiftUI

final class EmailViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var emailError: String?
    @Published var canSubmit: Bool = false

    private let emailValidationUsecase: EmailValidationUsecase
    private let setEmailUsecase: SetEmailUsecase
    private var coordinator: EmailCoordinator

    private(set) var cancellables = Set<AnyCancellable>()

    init(
        emailValidationUsecase: EmailValidationUsecase,
        setEmailUsecase: SetEmailUsecase,
        coordinator: EmailCoordinator
    ) {
        self.emailValidationUsecase = emailValidationUsecase
        self.setEmailUsecase = setEmailUsecase
        self.coordinator = coordinator

        $email
            .dropFirst()
            .removeDuplicates()
            .map(emailValidationUsecase.execute)
            .map { $0?.localizedDescription }
            .assign(to: &$emailError)

        $emailError
            .map { [weak self] emailError in
                guard let self = self else { return false }
                return emailError == nil && !email.isEmpty
            }
            .assign(to: &$canSubmit)
    }

    func didTapCountinue() {
        setEmailUsecase.execute(email: email)
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success: break
                // Email verification is sent to Email
//                    coordinator.push(.password)
                case let .failure(error):
                    coordinator.present(.error(title: "Error", subtitle: error.localizedDescription, didDismiss: {}))
                }
            }
            .store(in: &cancellables)
    }
}
