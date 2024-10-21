//
//  ContactInfoCoordinatorDeeplink.swift
//  TextValidator
//
//  Created by Alfian on 16/10/24.
//

import SwiftUI
import Swinject

class ContactInfoCoordinatorDeeplinkAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ContactInfoCoordinatorDeeplink.self) { (r, n: UINavigationController) in
            guard let wrapped = r.resolve(ContactInfoCoordinatorImpl.self, argument: n) else {
                fatalError()
            }
            return ContactInfoCoordinatorDeeplink(wrapped: wrapped)
        }
    }
}

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
    func start(didTapLogin: @escaping () -> Void) async {
        await wrapped.start(didTapLogin: didTapLogin)
    }

    @MainActor
    func start(_ deeplink: DeeplinkType, didTapLogin: @escaping () -> Void) async {
        await wrapped.start(didTapLogin: didTapLogin)
        let coordinator = EmailCoordinatorDeeplink(
            wrapped: EmailCoordinatorImpl(navigationController: navigationController)
        )
        await coordinator.start(deeplink)
    }

    @MainActor
    func push(_ page: ContactInfoCoordinatorPage) async {
        await wrapped.push(page)
    }

    func present(_ sheet: ContactInfoCoordinatorSheet) {
        wrapped.present(sheet)
    }
}
