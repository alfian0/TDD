//
//  EmailValidationUsecase.swift
//  TextValidator
//
//  Created by Alfian on 14/10/24.
//

import Foundation

final class EmailValidationUsecase: BaseValidationUsecase {
    func execute(input: String) -> TextValidationError? {
        return validate(input: input, regex: ValidationRegex.email, minLength: 5, maxLength: 254)
    }
}
