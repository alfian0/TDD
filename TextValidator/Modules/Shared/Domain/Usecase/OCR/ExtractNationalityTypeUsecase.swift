//
//  ExtractNationalityTypeUsecase.swift
//  TextValidator
//
//  Created by Alfian on 19/10/24.
//

final class ExtractNationalityTypeUsecase {
    func exec(text: String) -> NationalityType? {
        return NationalityType.allCases.first { text.contains($0.rawValue) }
    }
}
