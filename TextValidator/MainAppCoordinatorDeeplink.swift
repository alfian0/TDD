//
//  MainAppCoordinatorDeeplink.swift
//  TextValidator
//
//  Created by Alfian on 16/10/24.
//

import SwiftUI

enum DeeplinkType {
    case verifyEmail(link: String)
}

final class MainAppCoordinatorDeeplink: MainAppCoordinator {
    private let wrapped: MainAppCoordinator

    var childCoordinator: [any Coordinator] {
        get { wrapped.childCoordinator }
        set { wrapped.childCoordinator = newValue }
    }

    var navigationController: UINavigationController {
        get { wrapped.navigationController }
        set { wrapped.navigationController = newValue }
    }

    init(wrapped: MainAppCoordinator) {
        self.wrapped = wrapped
    }

    @MainActor
    func start(_ deeplink: DeeplinkType) {
        switch deeplink {
        case .verifyEmail:
            navigationController.dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                Task {
                    let coordinator = ContactInfoCoordinatorDeeplink(wrapped: ContactInfoCoordinatorImpl())
                    await coordinator.start(deeplink, didTapLogin: { [weak self] in
                        guard let self = self else { return }
                        navigationController.dismiss(animated: true) {
                            Task {
                                await self.present(.login)
                                self.childCoordinator.removeLast()
                            }
                        }
                    })
                    coordinator.navigationController.modalPresentationStyle = .fullScreen
                    self.childCoordinator.append(coordinator)
                    self.navigationController.showDetailViewController(coordinator.navigationController, sender: self.navigationController)
                }
            }
        }
    }

    func start() {
        wrapped.start()
    }

    @MainActor
    func present(_ sheet: MainAppCoordinatorSheet) async {
        await wrapped.present(sheet)
    }
}
