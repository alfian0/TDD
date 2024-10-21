//
//  ExtractMaritalStatusUsecase.swift
//  TextValidator
//
//  Created by Alfian on 19/10/24.
//

import Swinject

class ExtractMaritalStatusUsecaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ExtractMaritalStatusUsecase.self) { _ in
            ExtractMaritalStatusUsecase()
        }
    }
}

final class ExtractMaritalStatusUsecase {
    func exec(text: String) -> MarriedStatusType? {
        return MarriedStatusType.allCases.first { text.contains($0.rawValue) }
    }
}
