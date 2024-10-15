//
//  OTPCoordinator.swift
//  TextValidator
//
//  Created by Alfian on 09/10/24.
//

import SwiftUI

enum OTPCoordinatorSheet {
    case error(title: String, subtitle: String, didDismiss: () -> Void)
}

final class OTPCoordinator: Coordinator {
    var childCoordinator: [any Coordinator] = .init()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    @MainActor
    func start(type: OTPType, verificationID: String, didSuccess: @escaping () -> Void) {
        let vm = OTPViewModel(
            type: type,
            verificationID: verificationID,
            verifyOTPUsecase: VerifyOTPUsecase(
                repository: VerifyOTPRepository(service: FirebaseRegisterService())
            ),
            coordinator: self,
            didSuccess: didSuccess
        )
        let v = OTPView(viewModel: vm)
        let vc = UIHostingController(rootView: v)
        navigationController.show(vc, sender: navigationController)
    }

    func present(_ sheet: OTPCoordinatorSheet) {
        switch sheet {
        case let .error(title, subtitle, didDismiss):
            let coordinator = ErrorCoordinator()
            coordinator.start(title: title, subtitle: subtitle, didDismiss: { [weak self] in
                didDismiss()
                self?.navigationController.dismiss(animated: true)
            })
            coordinator.navigationController.modalPresentationStyle = .fullScreen
            navigationController.showDetailViewController(coordinator.navigationController, sender: navigationController)
        }
    }
}
