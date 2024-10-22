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

    @MainActor
    func start(
        selected: CountryCodeModel,
        items: [CountryCodeModel],
        didSelect: @escaping (CountryCodeModel) -> Void,
        didDismiss: @escaping () -> Void
    ) {
        guard let v = AppAssembler.shared.resolver.resolve(CountrySearchListView.self, arguments: selected, items, didSelect, didDismiss) else {
            return
        }
        let vc = UIHostingController(rootView: v)
        navigationController.show(vc, sender: navigationController)
    }
}
