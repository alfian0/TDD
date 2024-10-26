//
//  LoginViewAssembler.swift
//  TextValidator
//
//  Created by Alfian on 22/10/24.
//

import Swinject

@MainActor
final class LoginViewAssembler: @preconcurrency Assembly {
    func assemble(container: Swinject.Container) {
        container.register(LoginViewCoordinator.self) { _, n in
            LoginViewCoordinator(navigationController: n)
        }

        container.register(LoginViewModel.self) { (r, c: LoginViewCoordinator, dd: @escaping (() -> Void), ds: @escaping (() -> Void)) in
            guard let loginUsecase = r.resolve(LoginUsecase.self) else {
                fatalError()
            }
            guard let loginBiometricUsecase = r.resolve(LoginBiometricUsecase.self) else {
                fatalError()
            }
            guard let emailValidationUsecase = r.resolve(EmailValidationUsecase.self) else {
                fatalError()
            }
            return LoginViewModel(
                loginUsecase: loginUsecase,
                loginBiometricUsecase: loginBiometricUsecase,
                emailValidationUsecase: emailValidationUsecase,
                coordinator: c,
                didDismiss: dd,
                didFinish: ds
            )
        }

        container.register(LoginView.self) { (r, c: LoginViewCoordinator, dd: @escaping (() -> Void), ds: @escaping (() -> Void)) in
            guard let viewModel = r.resolve(LoginViewModel.self, arguments: c, dd, ds) else {
                fatalError()
            }
            return LoginView(viewModel: viewModel)
        }
    }
}
