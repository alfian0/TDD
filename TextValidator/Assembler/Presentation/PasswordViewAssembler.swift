//
//  PasswordViewAssembler.swift
//  TextValidator
//
//  Created by Alfian on 22/10/24.
//

import Swinject

@MainActor
final class PasswordViewAssembler: @preconcurrency Assembly {
    func assemble(container: Swinject.Container) {
        container.register(PasswordCoordinator.self) { _, n in
            PasswordCoordinator(navigationController: n)
        }

        container.register(PasswordViewModel.self) { (r, c: PasswordCoordinator) in
            guard let setPasswordUsecase = r.resolve(SetPasswordUsecase.self) else {
                fatalError()
            }
            guard let passwordStrengthUsecase = r.resolve(PasswordStrengthUsecase.self) else {
                fatalError()
            }
            return PasswordViewModel(setPasswordUsecase: setPasswordUsecase, passwordStrengthUsecase: passwordStrengthUsecase, coordinator: c)
        }

        container.register(PasswordView.self) { (r, c: PasswordCoordinator) in
            guard let viewModel = r.resolve(PasswordViewModel.self, argument: c) else {
                fatalError()
            }
            return PasswordView(viewModel: viewModel)
        }
    }
}
