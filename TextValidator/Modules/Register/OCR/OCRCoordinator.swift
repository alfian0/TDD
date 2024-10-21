//
//  OCRCoordinator.swift
//  TextValidator
//
//  Created by Alfian on 21/10/24.
//

import SwiftUI
import Swinject

class OCRViewCoordinatorAssembly: Assembly {
    func assemble(container: Container) {
        container.register(OCRViewCoordinator.self) { _, n in
            OCRViewCoordinator(navigationController: n)
        }
    }
}

enum OCRViewCoordinatorSheet {
    case error(title: String, subtitle: String, didDismiss: () -> Void)
}

final class OCRViewCoordinator: Coordinator {
    var childCoordinator: [any Coordinator] = .init()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    @MainActor
    func start() {
        guard let v = AppAssembler.shared.resolver.resolve(OCRView.self, argument: self) else {
            return
        }
        let vc = UIHostingController(rootView: v)
        navigationController.show(vc, sender: navigationController)
    }

    func present(_ sheet: OCRViewCoordinatorSheet) {
        switch sheet {
        case let .error(title, subtitle, didDismiss):
            let coordinator = ErrorCoordinator()
            coordinator.start(title: title, subtitle: subtitle, didDismiss: { [weak self] in
                didDismiss()
                self?.navigationController.dismiss(animated: true)
                self?.childCoordinator.removeLast()
            })
            coordinator.navigationController.modalPresentationStyle = .fullScreen
            childCoordinator.append(coordinator)
            navigationController.showDetailViewController(coordinator.navigationController, sender: navigationController)
        }
    }
}
