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
    func start(
        title: String,
        subtitle: String,
        count: Int,
        duration: Int,
        didResend: @escaping () -> Void,
        didChange: @escaping () -> Void,
        didSuccess: @escaping (String) -> Void
    ) {
        let vm = OTPViewFactory().createOTPViewModel(
            title: title,
            subtitle: subtitle,
            count: count,
            duration: duration,
            coordinator: self,
            didResend: didResend,
            didChange: didChange,
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
