//
//  EmailCoordinatorImpl.swift
//  TextValidator
//
//  Created by Alfian on 09/10/24.
//

import SwiftUI

enum EmailCoordinatorPage {
    case password
}

enum EmailCoordinatorSheet {
    case error(title: String, subtitle: String, didDismiss: () -> Void)
}

protocol EmailCoordinator: Coordinator {
    func start(viewState: EmailViewState) async
    func push(_ page: EmailCoordinatorPage) async
    func present(_ sheet: EmailCoordinatorSheet)
}

final class EmailCoordinatorImpl: EmailCoordinator {
    var childCoordinator: [any Coordinator] = .init()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    @MainActor
    func start(viewState: EmailViewState) {
        let vm = EmailViewModel(
            viewState: viewState,
            emailValidationUsecase: EmailValidationUsecase(),
            registerEmailUsecase: RegisterEmailUsecase(
                repository: RegisterEmailRepository(service: FirebaseAuthService()),
                emailValidationUsecase: EmailValidationUsecase()
            ),
            reloadUserUsecase: ReloadUserUsecase(
                repository: RegisterEmailRepository(service: FirebaseAuthService())
            ),
            coordinator: self
        )
        let v = EmailView(viewModel: vm)
        let vc = UIHostingController(rootView: v)
        navigationController.setViewControllers([vc], animated: true)
    }

    @MainActor
    func push(_ page: EmailCoordinatorPage) {
        switch page {
        case .password:
            let coordinator = PasswordCoordinator(navigationController: navigationController)
            coordinator.start()
        }
    }

    func present(_ sheet: EmailCoordinatorSheet) {
        switch sheet {
        case let .error(title, subtitle, didDismiss):
            let coordinator = ErrorCoordinator()
            coordinator.start(title: title, subtitle: subtitle, didDismiss: { [weak self] in
                didDismiss()
                self?.navigationController.dismiss(animated: true)
            })
            coordinator.navigationController.modalPresentationStyle = .fullScreen
            navigationController.showDetailViewController(coordinator.navigationController, sender: navigationController)
        }
    }
}
