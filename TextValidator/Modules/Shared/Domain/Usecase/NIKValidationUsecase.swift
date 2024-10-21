//
//  NIKValidationUsecase.swift
//  TextValidator
//
//  Created by Alfian on 21/10/24.
//

import Foundation

final class NIKValidationUsecase {
    func execute(input: String) -> TextValidationError? {
        guard !input.isEmpty else {
            return .EMPTY
        }

        guard input.count <= 16 else {
            return .TOO_LONG
        }

        let regex = #"^\d{16}$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: input) ? nil : .INVALID_FORMAT
    }
}
