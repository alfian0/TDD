//
//  ContactInfoCoordinatorDeeplink.swift
//  TextValidator
//
//  Created by Alfian on 16/10/24.
//

import SwiftUI

final class ContactInfoCoordinatorDeeplink: ContactInfoCoordinator {
    private let wrapped: ContactInfoCoordinator

    var childCoordinator: [any Coordinator] {
        get { wrapped.childCoordinator }
        set { wrapped.childCoordinator = newValue }
    }

    var navigationController: UINavigationController {
        get { wrapped.navigationController }
        set { wrapped.navigationController = newValue }
    }

    init(wrapped: ContactInfoCoordinator) {
        self.wrapped = wrapped
    }

    @MainActor
    func start(onLoginTapped didTapLogin: @escaping () -> Void) async {
        await wrapped.start(onLoginTapped: didTapLogin)
    }

    @MainActor
    func start(_ deeplink: DeeplinkType, didTapLogin: @escaping () -> Void) async {
        await wrapped.start(onLoginTapped: didTapLogin)
        let coordinator = EmailCoordinatorDeeplink(
            wrapped: EmailCoordinatorImpl(navigationController: navigationController)
        )
        await coordinator.start(deeplink)
    }

    @MainActor
    func push(_ page: ContactInfoCoordinatorPage) async {
        await wrapped.push(page)
    }

    func present(_ sheet: ContactInfoCoordinatorSheet) async {
        await wrapped.present(sheet)
    }
}
