//
//  OCRCoordinator.swift
//  TextValidator
//
//  Created by Alfian on 21/10/24.
//

import SwiftUI

enum OCRViewCoordinatorSheet {
    case error(title: String, subtitle: String, didDismiss: () -> Void)
}

final class OCRViewCoordinator: Coordinator {
    var childCoordinator: [any Coordinator] = .init()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    @MainActor
    func start() {
        let vm = OCRViewModel(
            extractKTPUsecase: ExtractKTPUsecase(repository: VisionRepositoryImpl(visionService: VisionService())),
            nameValidationUsecase: NameValidationUsecase(),
            nikValidationUsecase: NIKValidationUsecase(),
            ageValidationUsecase: AgeValidationUsecase(),
            coordinator: self
        )
        let v = OCRView(viewModel: vm)
        let vc = UIHostingController(rootView: v)
        navigationController.show(vc, sender: navigationController)
    }

    func present(_ sheet: OCRViewCoordinatorSheet) {
        switch sheet {
        case let .error(title, subtitle, didDismiss):
            let coordinator = ErrorCoordinator()
            coordinator.start(title: title, subtitle: subtitle, didDismiss: { [weak self] in
                didDismiss()
                self?.navigationController.dismiss(animated: true)
                self?.childCoordinator.removeLast()
            })
            coordinator.navigationController.modalPresentationStyle = .fullScreen
            childCoordinator.append(coordinator)
            navigationController.showDetailViewController(coordinator.navigationController, sender: navigationController)
        }
    }
}
