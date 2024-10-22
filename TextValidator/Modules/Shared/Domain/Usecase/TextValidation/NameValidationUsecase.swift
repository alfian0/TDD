//
//  NameValidationUsecase.swift
//  TextValidator
//
//  Created by Alfian on 03/10/24.
//

import Foundation

final class NameValidationUsecase: BaseValidationUsecase {
    func execute(input: String) -> TextValidationError? {
        return validate(input: input, regex: ValidationRegex.name, minLength: 3, maxLength: 20)
    }
}
