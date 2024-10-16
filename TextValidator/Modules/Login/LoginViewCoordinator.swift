//
//  LoginViewCoordinator.swift
//  TextValidator
//
//  Created by Alfian on 09/10/24.
//

import SwiftUI

final class LoginViewCoordinator: Coordinator {
    var childCoordinator: [any Coordinator] = .init()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    @MainActor
    func start(didDismiss: @escaping () -> Void) {
        let vm = LoginViewModel(
            loginUsecase: LoginUsecase(
                repository: LoginRepositoryImpl(service: FirebaseAuthService()),
                emailValidationUsecase: EmailValidationUsecase()
            ),
            loginBiometricUsecase: LoginBiometricUsecase(service: BiometricService()),
            emailValidationUsecase: EmailValidationUsecase(),
            coordinator: self,
            didDismiss: didDismiss
        )
        let v = LoginView(viewModel: vm)
        let vc = UIHostingController(rootView: v)
        navigationController.show(vc, sender: navigationController)
    }
}
