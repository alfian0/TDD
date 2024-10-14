//
//  MainAppView.swift
//  TextValidator
//
//  Created by Alfian on 14/10/24.
//

import SwiftUI

enum MainAppCoordinatorSheet {
    case login
    case register
}

final class MainAppCoordinator: Coordinator {
    var childCoordinator: [any Coordinator] = .init()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    func start() {
        guard navigationController.viewControllers.isEmpty else { return }
        let v = MainAppView(coordinator: self)
        let vc = UIHostingController(rootView: v)
        navigationController.show(vc, sender: navigationController)
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

struct MainAppView: View {
    var coordinator: MainAppCoordinator

    var body: some View {
        VStack {
            Button {
                coordinator.present(.login)
            } label: {
                Text("Login")
            }
            .buttonStyle(.bordered)

            Button {
                coordinator.present(.register)
            } label: {
                Text("Register")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    let coordinator = MainAppCoordinator()

    NavigationControllerWrapper(coordinator: coordinator)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            coordinator.start()
        }
}
