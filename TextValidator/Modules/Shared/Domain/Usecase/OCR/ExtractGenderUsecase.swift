//
//  ExtractGenderUsecase.swift
//  TextValidator
//
//  Created by Alfian on 19/10/24.
//

final class ExtractGenderUsecase {
    func exec(text: String) -> GenderType? {
        return GenderType.allCases.first { text.contains($0.rawValue) }
    }
}
