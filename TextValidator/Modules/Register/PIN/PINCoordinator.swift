//
//  PINCoordinator.swift
//  TextValidator
//
//  Created by Alfian on 10/10/24.
//

import SwiftUI

enum PINCoordinatorPage {
    case pin
}

final class PINCoordinator: Coordinator {
    var childCoordinator: [any Coordinator] = .init()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    func start(didFinish: @escaping () -> Void) {
        let vm = PINViewModel(
            count: 6,
            verifyPINUsecase: PINValidationUsecase(service: SetPINService()),
            coordinator: self,
            didFinish: didFinish
        )
        let v = PINView(viewModel: vm)
        let vc = UIHostingController(rootView: v)
        navigationController.show(vc, sender: navigationController)
    }

    func push(_ page: PINCoordinatorPage) {
        switch page {
        case .pin: break
        }
    }
}
