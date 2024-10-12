//
//  ErrorCoordinator.swift
//  TextValidator
//
//  Created by Alfian on 09/10/24.
//

import SwiftUI

final class ErrorCoordinator: Coordinator {
	var childCoordinator: [any Coordinator] = .init()
	var navigationController: UINavigationController
	
	init(navigationController: UINavigationController = UINavigationController()) {
		self.navigationController = navigationController
	}
	
	func start(title: String, subtitle: String, didDismiss: @escaping () -> Void) {
		let v = ErrorView(title: title, subtitle: subtitle, didDismiss: didDismiss)
		let vc = UIHostingController(rootView: v)
		navigationController.show(vc, sender: navigationController)
	}
}
