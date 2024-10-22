//
//  PhoneValidationUsecase.swift
//  TextValidator
//
//  Created by Alfian on 03/10/24.
//

import Foundation

final class PhoneValidationUsecase: BaseValidationUsecase {
    func execute(input: String) -> TextValidationError? {
        return validate(input: input, regex: ValidationRegex.phone, minLength: 5, maxLength: 15)
    }
}
