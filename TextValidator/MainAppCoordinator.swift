//
//  MainAppCoordinator.swift
//  TextValidator
//
//  Created by Alfian on 15/10/24.
//

import SwiftUI

enum MainAppCoordinatorSheet {
    case login
    case register
}

enum DeeplinkType {
    case verifyEmail(link: String)
}

final class MainAppCoordinator: Coordinator {
    var childCoordinator: [any Coordinator] = .init()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    func start() {
        let v = MainAppView(coordinator: self)
        let vc = UIHostingController(rootView: v)
        navigationController.show(vc, sender: navigationController)
    }

    func start(_ deeplink: DeeplinkType) {
        switch deeplink {
        case .verifyEmail:
            navigationController.dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                let coordinator = DefaultContactInfoCoordinator()
                coordinator.start(deeplink, didTapLogin: { [weak self] in
                    guard let self = self else { return }
                    navigationController.dismiss(animated: true) {
                        self.present(.login)
                        self.childCoordinator.removeLast()
                    }
                })
                coordinator.navigationController.modalPresentationStyle = .fullScreen
                childCoordinator.append(coordinator)
                navigationController.showDetailViewController(coordinator.navigationController, sender: navigationController)
            }
        }
    }

    func present(_ sheet: MainAppCoordinatorSheet) {
        switch sheet {
        case .login:
            let coordinator = LoginViewCoordinator()
            coordinator.start(didDismiss: { [weak self] in
                guard let self = self else { return }
                navigationController.dismiss(animated: true) {
                    self.childCoordinator.removeLast()
                }
            })
            coordinator.navigationController.modalPresentationStyle = .fullScreen
            childCoordinator.append(coordinator)
            navigationController.showDetailViewController(coordinator.navigationController, sender: navigationController)

        case .register:
            let coordinator = DefaultContactInfoCoordinator()
            coordinator.start(didTapLogin: { [weak self] in
                guard let self = self else { return }
                navigationController.dismiss(animated: true) {
                    self.present(.login)
                    self.childCoordinator.removeLast()
                }
            })
            coordinator.navigationController.modalPresentationStyle = .fullScreen
            childCoordinator.append(coordinator)
            navigationController.showDetailViewController(coordinator.navigationController, sender: navigationController)
        }
    }
}
