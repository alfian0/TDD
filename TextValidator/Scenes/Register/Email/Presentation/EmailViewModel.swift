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
    case waitingForVerification(verificationLink: String?)

    var title: String {
        switch self {
        case .formInput:
            return "Add your email"
        case .waitingForVerification:
            return "Verify your email address"
        }
    }

    var subtitle: String {
        switch self {
        case .formInput:
            return "Please input your personal email address to receive any notificatio"
        case .waitingForVerification:
            return "We have just send email verification link on your email. Please check email and click on that link to verify your email address."
        }
    }
}

final class EmailViewModel: ObservableObject {
    @Published var email: String
    @Published var emailError: String?
    @Published var canSubmit: Bool = false
    @Published var viewState: EmailViewState

    private let emailValidationUsecase: EmailValidationUsecase
    private let setEmailUsecase: SetEmailUsecase
    private var coordinator: EmailCoordinator

    private(set) var cancellables = Set<AnyCancellable>()

    init(
        email: String,
        viewState: EmailViewState,
        emailValidationUsecase: EmailValidationUsecase,
        setEmailUsecase: SetEmailUsecase,
        coordinator: EmailCoordinator
    ) {
        self.email = email
        self.viewState = viewState
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
                return emailError == nil && !self.email.isEmpty
            }
            .assign(to: &$canSubmit)

        switch viewState {
        case let .waitingForVerification(verificationLink):
            guard let verificationLink = verificationLink else { return }
            if let url = URL(string: verificationLink) {
                UIApplication.shared.open(url)
            }
        default: break
        }
    }

    func didTapCountinue() {
        setEmailUsecase.execute(email: email)
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    viewState = .waitingForVerification(verificationLink: nil)
                case let .failure(error):
                    coordinator.present(.error(title: "Error", subtitle: error.localizedDescription, didDismiss: {}))
                }
            }
            .store(in: &cancellables)
    }
}
