//
//  EmailViewModel.swift
//  TextValidator
//
//  Created by Alfian on 14/10/24.
//

import Combine
import SwiftUI

enum EmailViewState {
    case formInput
    case waitingForVerification(link: String)
}

@MainActor
final class EmailViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var emailError: String?
    @Published var canSubmit: Bool = false
    @Published var viewState: EmailViewState

    private let emailValidationUsecase: EmailValidationUsecase
    private let registerEmailUsecase: RegisterEmailUsecase
    private let reloadUserUsecase: ReloadUserUsecase
    private let verificationEmailUsecase: VerificationEmailUsecase
    private var coordinator: EmailCoordinator

    private(set) var cancellables = Set<AnyCancellable>()

    init(
        viewState: EmailViewState,
        emailValidationUsecase: EmailValidationUsecase,
        registerEmailUsecase: RegisterEmailUsecase,
        reloadUserUsecase: ReloadUserUsecase,
        verificationEmailUsecase: VerificationEmailUsecase,
        coordinator: EmailCoordinator
    ) {
        self.viewState = viewState
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

    func verification() async {
        switch viewState {
        case let .waitingForVerification(link):
            let result = await verificationEmailUsecase.execute(link: link)
            switch result {
            case let .success(user):
                print(user)
            case let .failure(error):
                coordinator.present(.error(title: "Error", subtitle: error.localizedDescription, didDismiss: {}))
            }
        default: break
        }
    }

    func didTapCountinue() async {
        let result = await registerEmailUsecase.execute(email: email)

        switch result {
        case .success:
            viewState = .waitingForVerification(link: "")
        case let .failure(error):
            coordinator.present(.error(title: "Error", subtitle: error.localizedDescription, didDismiss: {}))
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
