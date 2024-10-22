//
//  CountryCodeViewAssembler.swift
//  TextValidator
//
//  Created by Alfian on 22/10/24.
//

import Swinject

@MainActor
final class CountryCodeViewAssembler: @preconcurrency Assembly {
    func assemble(container: Swinject.Container) {
        container.register(CountryCodeViewModel.self) { (_, s: CountryCodeModel, i: [CountryCodeModel], ds: @escaping (CountryCodeModel) -> Void, dd: @escaping () -> Void) in
            CountryCodeViewModel(selected: s, items: i, didSelect: ds, didDismiss: dd)
        }

        container.register(CountrySearchListView.self) { (r, s: CountryCodeModel, i: [CountryCodeModel], ds: @escaping (CountryCodeModel) -> Void, dd: @escaping () -> Void) in
            guard let viewModel = r.resolve(CountryCodeViewModel.self, arguments: s, i, ds, dd) else {
                fatalError()
            }
            return CountrySearchListView(viewModel: viewModel)
        }

        container.register(CountryCodeCoordinator.self) { _, n in
            CountryCodeCoordinator(navigationController: n)
        }
    }
}
