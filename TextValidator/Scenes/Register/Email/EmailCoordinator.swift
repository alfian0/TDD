//
//  EmailCoordinator.swift
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

final class EmailCoordinator: Coordinator {
    var childCoordinator: [any Coordinator] = .init()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    func start(email: String, viewState: EmailViewState) {
        let vm = EmailViewModel(
            email: email,
            viewState: viewState,
            emailValidationUsecase: EmailValidationUsecase(),
            setEmailUsecase: SetEmailUsecase(service: EmailService()),
            coordinator: self
        )
        let v = EmailView(viewModel: vm)
        let vc = UIHostingController(rootView: v)
        navigationController.viewControllers = [vc]
    }

    func start(_ deeplink: DeeplinkType) {
        switch deeplink {
        case let .verifyEmail(link):
            start(email: "alfian.official.mail@gmail.com", viewState: .waitingForVerification(verificationLink: link))
        }
    }

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
