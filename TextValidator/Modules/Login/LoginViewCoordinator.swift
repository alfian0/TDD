//
//  LoginViewCoordinator.swift
//  TextValidator
//
//  Created by Alfian on 09/10/24.
//

import SwiftUI

final class LoginViewCoordinator: Coordinator {
    var childCoordinator: [any Coordinator] = .init()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    @MainActor
    func start(didDismiss: @escaping () -> Void, didFinish: @escaping () -> Void) {
        guard let v = AppAssembler.shared.resolver.resolve(LoginView.self, arguments: self, didDismiss, didFinish) else {
            return
        }
        let vc = UIHostingController(rootView: v)
        navigationController.show(vc, sender: navigationController)
    }
}
