//
//  MainAppCoordinatorImpl.swift
//  TextValidator
//
//  Created by Alfian on 15/10/24.
//

import SwiftUI

enum MainAppCoordinatorSheet {
    case login
    case register

    // MARK: Testing Purpose

    case ocr
}

protocol MainAppCoordinator: Coordinator {
    func start()
    func present(_ sheet: MainAppCoordinatorSheet) async
}

final class MainAppCoordinatorImpl: MainAppCoordinator {
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

    @MainActor
    func present(_ sheet: MainAppCoordinatorSheet) {
        switch sheet {
        case .login:
            guard let coordinator = AppAssembler.shared.resolver.resolve(LoginViewCoordinator.self, argument: UINavigationController()) else {
                return
            }
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
            guard let coordinator = AppAssembler.shared.resolver.resolve(ContactInfoCoordinatorImpl.self, argument: UINavigationController()) else {
                return
            }
            coordinator.start(onLoginTapped: { [weak self] in
                guard let self = self else { return }
                navigationController.dismiss(animated: true) {
                    self.present(.login)
                    self.childCoordinator.removeLast()
                }
            })
            coordinator.navigationController.modalPresentationStyle = .fullScreen
            childCoordinator.append(coordinator)
            navigationController.showDetailViewController(coordinator.navigationController, sender: navigationController)

        case .ocr:
            guard let coordinator = AppAssembler.shared.resolver.resolve(OCRViewCoordinator.self, argument: UINavigationController()) else {
                return
            }
            coordinator.start()
            coordinator.navigationController.modalPresentationStyle = .fullScreen
            childCoordinator.append(coordinator)
            navigationController.showDetailViewController(coordinator.navigationController, sender: navigationController)
        }
    }
}
