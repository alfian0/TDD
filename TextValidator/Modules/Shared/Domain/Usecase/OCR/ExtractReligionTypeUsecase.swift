//
//  ExtractReligionTypeUsecase.swift
//  TextValidator
//
//  Created by Alfian on 19/10/24.
//

final class ExtractReligionTypeUsecase {
    func exec(text: String) -> ReligionType? {
        let texts = text.components(separatedBy: ":")
        return texts.compactMap { text in
            ReligionType.allCases.first { $0.rawValue.hasPrefix(text.uppercased()) }
        }.first
    }
}
