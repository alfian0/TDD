//
//  Coordinator.swift
//  TextValidator
//
//  Created by Alfian on 09/10/24.
//

import SwiftUI

public protocol Coordinator: AnyObject {
    var childCoordinator: [any Coordinator] { get set }
    var navigationController: UINavigationController { get set }
}

extension Coordinator {
    // MARK: - Helpers

    func presentModal(_ coordinator: any Coordinator, style: UIModalPresentationStyle = .fullScreen) {
        coordinator.navigationController.modalPresentationStyle = style
        childCoordinator.append(coordinator)
        navigationController.showDetailViewController(coordinator.navigationController, sender: nil)
    }

    func dismissCoordinator(_ coordinator: any Coordinator, completion: @escaping () -> Void) {
        navigationController.dismiss(animated: true, completion: {
            self.removeCoordinator(coordinator)
            completion()
        })
    }

    func removeCoordinator(_ coordinator: any Coordinator) {
        if let index = childCoordinator.firstIndex(where: { $0 === coordinator }) {
            childCoordinator.remove(at: index)
        }
    }
}
