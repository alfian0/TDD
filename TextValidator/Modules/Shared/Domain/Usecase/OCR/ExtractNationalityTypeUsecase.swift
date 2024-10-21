//
//  ExtractNationalityTypeUsecase.swift
//  TextValidator
//
//  Created by Alfian on 19/10/24.
//

import Swinject

class ExtractNationalityTypeUsecaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ExtractNationalityTypeUsecase.self) { _ in
            ExtractNationalityTypeUsecase()
        }
    }
}

final class ExtractNationalityTypeUsecase {
    func exec(text: String) -> NationalityType? {
        return NationalityType.allCases.first { text.contains($0.rawValue) }
    }
}
