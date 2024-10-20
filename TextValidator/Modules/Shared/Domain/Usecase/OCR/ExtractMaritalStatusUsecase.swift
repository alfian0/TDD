//
//  ExtractMaritalStatusUsecase.swift
//  TextValidator
//
//  Created by Alfian on 19/10/24.
//

final class ExtractMaritalStatusUsecase {
    func exec(text: String) -> MarriedStatusType? {
        return MarriedStatusType.allCases.first { text.contains($0.rawValue) }
    }
}
