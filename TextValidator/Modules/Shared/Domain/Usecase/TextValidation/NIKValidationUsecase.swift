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

        let regex = "^((1[1-9])|(21)|([37][1-6])|(5[1-4])|(6[1-5])|([8-9][1-2]))[0-9]{2}[0-9]{2}(([0-6][0-9])|(7[0-1]))((0[1-9])|(1[0-2]))([0-9]{2})[0-9]{4}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: input) ? nil : .INVALID_FORMAT
    }
}
