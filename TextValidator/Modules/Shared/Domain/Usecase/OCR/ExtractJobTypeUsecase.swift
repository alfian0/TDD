//
//  ExtractJobTypeUsecase.swift
//  TextValidator
//
//  Created by Alfian on 19/10/24.
//

import Swinject

class ExtractJobTypeUsecaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ExtractJobTypeUsecase.self) { _ in
            ExtractJobTypeUsecase()
        }
    }
}

final class ExtractJobTypeUsecase {
    func exec(text: String) -> JobType? {
        JobType.allCases.first { $0.rawValue.hasPrefix(text.uppercased()) }
    }
}
