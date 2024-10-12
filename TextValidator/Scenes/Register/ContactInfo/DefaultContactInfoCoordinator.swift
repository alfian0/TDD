//
//  ContactInfoCoordinator.swift
//  TextValidator
//
//  Created by Alfian on 09/10/24.
//

import SwiftUI

enum ContactInfoCoordinatorPage {
	case otp(type: OTPType)
	case email
}

enum ContactInfoCoordinatorSheet {
	case error(title: String, subtitle: String, didDismiss: () -> Void)
	case login
	case countryCode(
		selected: CountryCodeModel,
		items: [CountryCodeModel],
		didSelect: (CountryCodeModel) -> Void,
		didDismiss: () -> Void
	)
}

protocol ContactInfoCoordinator {
	func start()
	func push(_ page: ContactInfoCoordinatorPage)
	func present(_ sheet: ContactInfoCoordinatorSheet)
}

final class DefaultContactInfoCoordinator: Coordinator, ContactInfoCoordinator {
	var childCoordinator: [any Coordinator] = .init()
	var navigationController: UINavigationController
	
	init(navigationController: UINavigationController = UINavigationController()) {
		self.navigationController = navigationController
	}
	
	func start() {
		guard navigationController.viewControllers.isEmpty else { return }
		let vm = ContactInfoViewModel(
			fullnameValidationUsecase: FullNameValidationUsecase(),
			phoneValidationUsecase: PhoneValidationUsecase(),
			countryCodeUsecase: DefaultCountryCodeUsecase(service: DefaultCountryCodeService()),
			checkContactInfoUsecase: DefaultCheckContactInfoUsecase(service: DefaultCheckContactInfoService()),
			coordinator: self
		)
		let v = ContactInfoView(viewModel: vm)
		let vc = UIHostingController(rootView: v)
		
		navigationController.show(vc, sender: navigationController)
	}
	
	func push(_ page: ContactInfoCoordinatorPage) {
		switch page {
			case let .otp(type):
				let coordinator = OTPCoordinator(navigationController: navigationController)
				coordinator.start(type: type)
				
			case .email:
				let coordinator = EmailCoordinator(navigationController: navigationController)
				coordinator.start()
				
		}
	}
	
	func present(_ sheet: ContactInfoCoordinatorSheet) {
		switch sheet {
			case let .error(title, subtitle, didDismiss):
				let coordinator = ErrorCoordinator()
				coordinator.start(title: title, subtitle: subtitle, didDismiss: { [weak self] in
					didDismiss()
					self?.navigationController.dismiss(animated: true)
				})
				coordinator.navigationController.modalPresentationStyle = .fullScreen
				navigationController.showDetailViewController(coordinator.navigationController, sender: navigationController)
				
			case .login:
				let coordinator = LoginViewCoordinator()
				coordinator.start()
				coordinator.navigationController.modalPresentationStyle = .fullScreen
				childCoordinator.append(coordinator)
				navigationController.showDetailViewController(coordinator.navigationController, sender: navigationController)
				
			case let .countryCode(selected, items, didSelect, didDismiss):
				let coordinator = CountryCodeCoordinator()
				coordinator.start(
					selected: selected,
					items: items,
					didSelect: { [weak self] item in
						didSelect(item)
						self?.navigationController.dismiss(animated: true)
						self?.childCoordinator.removeLast()
					},
					didDismiss: { [weak self] in
						didDismiss()
						self?.navigationController.dismiss(animated: true)
						self?.childCoordinator.removeLast()
					}
				)
				coordinator.navigationController.modalPresentationStyle = .fullScreen
				childCoordinator.append(coordinator)
				navigationController.showDetailViewController(coordinator.navigationController, sender: navigationController)
				
		}
	}
}
