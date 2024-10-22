//
//  NameValidationUsecase.swift
//  TextValidator
//
//  Created by Alfian on 03/10/24.
//

import Foundation

final class NameValidationUsecase {
    func execute(input: String) -> TextValidationError? {
        guard !input.isEmpty else {
            return .EMPTY
        }

        guard input.count > 3 else {
            return .TOO_SHORT
        }

        guard input.count <= 20 else {
            return .TOO_LONG
        }

        let regex = "^[A-Za-z .,]{3,20}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: input) ? nil : .INVALID_FORMAT
    }
}
