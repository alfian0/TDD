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
    func exec(texts: [String]) -> GenderType? {
        let texts = texts.filter { $0.regex(with: "^[^0-9]+$") }
        return GenderType.allCases.min { jobType1, jobType2 in
            let minDistance1 = texts.map { levenshteinDistance($0, jobType1.rawValue) }.min() ?? Int.max
            let minDistance2 = texts.map { levenshteinDistance($0, jobType2.rawValue) }.min() ?? Int.max
            return minDistance1 < minDistance2
        }
    }
}
