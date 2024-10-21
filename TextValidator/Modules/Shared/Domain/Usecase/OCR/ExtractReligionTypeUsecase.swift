//
//  ExtractReligionTypeUsecase.swift
//  TextValidator
//
//  Created by Alfian on 19/10/24.
//

import Swinject

class ExtractReligionTypeUsecaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ExtractReligionTypeUsecase.self) { _ in
            ExtractReligionTypeUsecase()
        }
    }
}

final class ExtractReligionTypeUsecase {
    func exec(text: String) -> ReligionType? {
        ReligionType.allCases.first { $0.rawValue.hasPrefix(text.uppercased()) }
    }
}
