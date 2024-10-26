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
    case password

    // MARK: Testing Purpose

    case ocr
}

enum MainAppCoordinatorPage {
    case home
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
        navigationController.setViewControllers([vc], animated: false)
    }

    @MainActor
    func push(_ page: MainAppCoordinatorPage) {
        switch page {
        case .home:
            let v = HomeView()
            let vc = UIHostingController(rootView: v)
            navigationController.setViewControllers([vc], animated: false)
        }
    }

    @MainActor
    func present(_ sheet: MainAppCoordinatorSheet) {
        switch sheet {
        case .login:
            guard let coordinator = AppAssembler.shared.resolver.resolve(LoginViewCoordinator.self, argument: UINavigationController()) else {
                return
            }
            coordinator.start(
                didDismiss: { [weak self] in
                    guard let self = self else { return }
                    dismissCoordinator(coordinator, completion: {})
                }, didFinish: { [weak self] in
                    guard let self = self else { return }
                    dismissCoordinator(coordinator, completion: {
                        self.push(.home)
                    })
                }
            )
            coordinator.navigationController.modalPresentationStyle = .fullScreen
            presentModal(coordinator)

        case .register:
            guard let coordinator = AppAssembler.shared.resolver.resolve(ContactInfoCoordinatorImpl.self, argument: UINavigationController()) else {
                return
            }
            coordinator.start(onLoginTapped: { [weak self] in
                guard let self = self else { return }
                dismissCoordinator(coordinator, completion: {
                    self.present(.login)
                })
            })
            presentModal(coordinator)

        case .ocr:
            guard let coordinator = AppAssembler.shared.resolver.resolve(OCRViewCoordinator.self, argument: UINavigationController()) else {
                return
            }
            coordinator.start()
            presentModal(coordinator)

        case .password:
            guard let coordinator = childCoordinator.last else {
                password()
                return
            }
            dismissCoordinator(coordinator, completion: { [weak self] in
                guard let self = self else { return }
                password()
            })
        }
    }

    @MainActor
    private func password() {
        guard let coordinator = AppAssembler.shared.resolver.resolve(PasswordCoordinator.self, argument: UINavigationController()) else {
            return
        }
        coordinator.start()
        presentModal(coordinator)
    }
}
