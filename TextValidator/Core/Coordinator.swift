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

    func finish()
}

extension Coordinator {
    func finish() {
        if navigationController.viewControllers.count == 1 {
            let vc = UIAlertController(title: "Error", message: "You start from this page so you can do pop", preferredStyle: .alert)
            vc.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            navigationController.showDetailViewController(vc, sender: navigationController)
        } else {
            navigationController.popViewController(animated: true)
        }
    }
}
