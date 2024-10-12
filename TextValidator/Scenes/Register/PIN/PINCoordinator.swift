//
//  PINCoordinator.swift
//  TextValidator
//
//  Created by Alfian on 10/10/24.
//

import SwiftUI

final class PINCoordinator: Coordinator {
	var childCoordinator: [any Coordinator] = .init()
	var navigationController: UINavigationController
	
	init(navigationController: UINavigationController = UINavigationController()) {
		self.navigationController = navigationController
	}
	
	func start() {
		let vm = PINViewModel(
			count: 6,
			verifyPINUsecase: VerifyPINUsecase(service: SetPINService()),
			coordinator: self
		)
		let v = PINView(viewModel: vm)
		let vc = UIHostingController(rootView: v)
		navigationController.show(vc, sender: navigationController)
	}
	
	func goToPassword() {
		let coordinator = PasswordCoordinator(navigationController: navigationController)
		coordinator.start()
	}
}