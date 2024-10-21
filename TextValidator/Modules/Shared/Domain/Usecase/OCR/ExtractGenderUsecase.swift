//
//  ExtractGenderUsecase.swift
//  TextValidator
//
//  Created by Alfian on 19/10/24.
//

import Swinject

class ExtractGenderUsecaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ExtractGenderUsecase.self) { _ in
            ExtractGenderUsecase()
        }
    }
}

final class ExtractGenderUsecase {
    func exec(text: String) -> GenderType? {
        GenderType.allCases.first { $0.rawValue.hasPrefix(text.uppercased()) }
    }
}
