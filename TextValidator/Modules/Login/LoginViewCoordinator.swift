//
//  LoginViewCoordinator.swift
//  TextValidator
//
//  Created by Alfian on 09/10/24.
//

import SwiftUI
import Swinject

class LoginViewCoordinatorAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LoginViewCoordinator.self) { _, n in
            LoginViewCoordinator(navigationController: n)
        }
    }
}

final class LoginViewCoordinator: Coordinator {
    var childCoordinator: [any Coordinator] = .init()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    @MainActor
    func start(didDismiss: @escaping () -> Void) {
        guard let v = AppAssembler.shared.resolver.resolve(LoginView.self, arguments: self, didDismiss) else {
            return
        }
        let vc = UIHostingController(rootView: v)
        navigationController.show(vc, sender: navigationController)
    }
}
