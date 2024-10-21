//
//  FilterCountryCodesUsecase.swift
//  TextValidator
//
//  Created by Alfian on 04/10/24.
//

import Swinject

class FilterCountryCodesUsecaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(FilterCountryCodesUsecase.self) { _ in
            FilterCountryCodesUsecase()
        }
    }
}

struct FilterCountryCodesUsecase {
    struct Input {
        let search: String
        let items: [CountryCodeModel]
        let selected: CountryCodeModel
    }

    func execute(input: Input) -> [CountryCodeModel] {
        var results = input.items.filter { $0.name != input.selected.name }

        if !input.search.isEmpty {
            results = results.filter {
                $0.name.lowercased().contains(input.search.lowercased()) ||
                    $0.code.lowercased() == input.search.lowercased()
            }
        }

        return [input.selected] + results
    }
}
