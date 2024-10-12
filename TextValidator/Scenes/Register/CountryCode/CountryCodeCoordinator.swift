//
//  CountryCodeCoordinator.swift
//  TextValidator
//
//  Created by Alfian on 09/10/24.
//

import SwiftUI

final class CountryCodeCoordinator: Coordinator {
	var childCoordinator: [any Coordinator] = .init()
	var navigationController: UINavigationController
	
	init(navigationController: UINavigationController = UINavigationController()) {
		self.navigationController = navigationController
	}
	
	func start(
		selected: CountryCodeModel,
		items: [CountryCodeModel],
		didSelect: @escaping (CountryCodeModel) -> Void,
		didDismiss: @escaping () -> Void
	) {
		let vm = CountryCodeViewModel(selected: selected, items: items, didSelect: didSelect, didDismiss: didDismiss)
		let v = CountrySearchListView(viewModel: vm)
		let vc = UIHostingController(rootView: v)
		navigationController.show(vc, sender: navigationController)
	}
}
