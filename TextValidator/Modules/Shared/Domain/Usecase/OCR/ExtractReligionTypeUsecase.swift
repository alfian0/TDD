//
//  ExtractReligionTypeUsecase.swift
//  TextValidator
//
//  Created by Alfian on 19/10/24.
//

final class ExtractReligionTypeUsecase {
    func exec(text: String) -> ReligionType? {
        return ReligionType.allCases.first { text.contains($0.rawValue) }
    }
}
