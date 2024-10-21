//
//  ExtractReligionTypeUsecase.swift
//  TextValidator
//
//  Created by Alfian on 19/10/24.
//

final class ExtractReligionTypeUsecase {
    func exec(text: String) -> ReligionType? {
        ReligionType.allCases.first { $0.rawValue.hasPrefix(text.uppercased()) }
    }
}
