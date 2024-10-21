//
//  ExtractGenderUsecase.swift
//  TextValidator
//
//  Created by Alfian on 19/10/24.
//

final class ExtractGenderUsecase {
    func exec(text: String) -> GenderType? {
        let texts = text.components(separatedBy: ":")
        return texts.compactMap { text in
            GenderType.allCases.first { $0.rawValue.hasPrefix(text.uppercased()) }
        }.first
    }
}
