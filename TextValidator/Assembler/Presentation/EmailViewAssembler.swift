//
//  EmailViewAssembler.swift
//  TextValidator
//
//  Created by Alfian on 22/10/24.
//

import Swinject
import UIKit

@MainActor
final class EmailViewAssembler: @preconcurrency Assembly {
    func assemble(container: Swinject.Container) {
        container.register(EmailCoordinatorImpl.self) { _, n in
            EmailCoordinatorImpl(navigationController: n)
        }

        container.register(EmailCoordinatorDeeplink.self) { (r, n: UINavigationController) in
            guard let wrapped = r.resolve(EmailCoordinatorImpl.self, argument: n) else {
                fatalError()
            }
            return EmailCoordinatorDeeplink(wrapped: wrapped)
        }

        container.register(EmailViewModel.self) { (r, v: EmailViewState, c: EmailCoordinator) in
            guard let emailValidationUsecase = r.resolve(EmailValidationUsecase.self) else {
                fatalError()
            }
            guard let registerEmailUsecase = r.resolve(RegisterEmailUsecase.self) else {
                fatalError()
            }
            guard let reloadUserUsecase = r.resolve(ReloadUserUsecase.self) else {
                fatalError()
            }
            guard let verificationEmailUsecase = r.resolve(VerificationEmailUsecase.self) else {
                fatalError()
            }
            return EmailViewModel(
                viewState: v,
                emailValidationUsecase: emailValidationUsecase,
                registerEmailUsecase: registerEmailUsecase,
                reloadUserUsecase: reloadUserUsecase,
                verificationEmailUsecase: verificationEmailUsecase,
                coordinator: c
            )
        }

        container.register(EmailView.self) { (r, v: EmailViewState, c: EmailCoordinator) in
            guard let viewModel = r.resolve(EmailViewModel.self, arguments: v, c) else {
                fatalError()
            }
            return EmailView(viewModel: viewModel)
        }
    }
}