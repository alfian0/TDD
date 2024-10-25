//
//  EmailViewModel.swift
//  TextValidator
//
//  Created by Alfian on 14/10/24.
//

import Combine
import SwiftUI

@MainActor
final class EmailViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var emailError: String?
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var canSubmit: Bool = false

    private let emailValidationUsecase: EmailValidationUsecase
    private let registerEmailUsecase: RegisterEmailUsecase
    private let reloadUserUsecase: ReloadUserUsecase
    private let verificationEmailUsecase: VerificationEmailUsecase
    private var coordinator: EmailCoordinator

    private(set) var cancellables = Set<AnyCancellable>()

    init(
        emailValidationUsecase: EmailValidationUsecase,
        registerEmailUsecase: RegisterEmailUsecase,
        reloadUserUsecase: ReloadUserUsecase,
        verificationEmailUsecase: VerificationEmailUsecase,
        coordinator: EmailCoordinator
    ) {
        self.emailValidationUsecase = emailValidationUsecase
        self.registerEmailUsecase = registerEmailUsecase
        self.reloadUserUsecase = reloadUserUsecase
        self.verificationEmailUsecase = verificationEmailUsecase
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
                return emailError == nil && !self.email.isEmpty
            }
            .assign(to: &$canSubmit)
    }

    func didTapCountinue() {
        isLoading = true
        defer {
            isLoading = false
        }
        Task {
            let result = await registerEmailUsecase.execute(email: email)

            switch result {
            case .success:
                print("---")
            case let .failure(error):
                coordinator.present(.error(title: "Error", subtitle: error.localizedDescription, didDismiss: {}))
            }
        }
    }

    func reload() async {
        let result = await reloadUserUsecase.execute()

        switch result {
        case let .success(isEmailVerified):
            guard isEmailVerified else { return }
            await coordinator.push(.password)
        case let .failure(error):
            coordinator.present(.error(title: "Error", subtitle: error.localizedDescription, didDismiss: {}))
        }
    }
}
