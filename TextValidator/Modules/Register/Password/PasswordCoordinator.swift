//
//  PasswordCoordinator.swift
//  TextValidator
//
//  Created by Alfian on 09/10/24.
//

import SwiftUI
import Swinject

class PasswordCoordinatorAssembly: Assembly {
    func assemble(container: Container) {
        container.register(PasswordCoordinator.self) { _, n in
            PasswordCoordinator(navigationController: n)
        }
    }
}

enum PasswordCoordinatorPage {
    case pin
}

enum PasswordCoordinatorSheet {
    case error(title: String, subtitle: String, didDismiss: () -> Void)
}

final class PasswordCoordinator: Coordinator {
    var childCoordinator: [any Coordinator] = .init()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    @MainActor
    func start() {
        guard let v = AppAssembler.shared.resolver.resolve(PasswordView.self, argument: self) else {
            return
        }
        let vc = UIHostingController(rootView: v)
        navigationController.setViewControllers([vc], animated: true)
    }

    @MainActor
    func push(_ page: PasswordCoordinatorPage) {
        switch page {
        case .pin:
            let coordinator = PINCoordinator(navigationController: navigationController)
            coordinator.start(didFinish: {})
        }
    }

    func present(_ sheet: PasswordCoordinatorSheet) {
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
