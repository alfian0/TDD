//
//  OTPCoordinator.swift
//  TextValidator
//
//  Created by Alfian on 09/10/24.
//

import SwiftUI

enum OTPCoordinatorPage {
	case pin
}

final class OTPCoordinator: Coordinator {
	var childCoordinator: [any Coordinator] = .init()
	var navigationController: UINavigationController
	
	init(navigationController: UINavigationController = UINavigationController()) {
		self.navigationController = navigationController
	}
	
	func start(type: OTPType) {
		let vm = OTPViewModel(type: type, coordinator: self)
		let v = OTPView(viewModel: vm)
		let vc = UIHostingController(rootView: v)
		navigationController.show(vc, sender: navigationController)
	}
	
	func push(_ page: OTPCoordinatorPage) {
		switch page {
			case .pin:
				let coordinator = PINCoordinator(navigationController: navigationController)
				coordinator.start()
		}
	}
}
