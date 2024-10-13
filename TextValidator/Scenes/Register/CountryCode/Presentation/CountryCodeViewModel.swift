//
//  CountryCodeViewModel.swift
//  TextValidator
//
//  Created by Alfian on 04/10/24.
//

import Combine
import Foundation

class CountryCodeViewModel: ObservableObject {
    @Published var search: String = ""
    @Published private(set) var filteredItems: [CountryCodeModel]
    let selected: CountryCodeModel
    let items: [CountryCodeModel]
    let didSelect: (CountryCodeModel) -> Void
    let didDismiss: () -> Void

    private let filterUsecase = FilterCountryCodesUsecase()

    var cancellables = Set<AnyCancellable>()

    init(
        selected: CountryCodeModel,
        items: [CountryCodeModel],
        didSelect: @escaping (CountryCodeModel) -> Void,
        didDismiss: @escaping () -> Void
    ) {
        self.selected = selected
        self.items = items
        filteredItems = items
        self.didSelect = didSelect
        self.didDismiss = didDismiss

        filterItems(search: "")

        $search
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] text in
                self?.filterItems(search: text)
            }
            .store(in: &cancellables)
    }

    private func filterItems(search: String) {
        let input = FilterCountryCodesUsecase.Input(
            search: search,
            items: items,
            selected: selected
        )
        filteredItems = filterUsecase.execute(input: input)
    }

    func cancel() {
        for cancellable in cancellables {
            cancellable.cancel()
        }
        cancellables.removeAll()
    }
}
