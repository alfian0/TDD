//
//  NIKValidationUsecase.swift
//  TextValidator
//
//  Created by Alfian on 21/10/24.
//

import Foundation

final class NIKValidationUsecase: BaseValidationUsecase {
    func execute(input: String) -> TextValidationError? {
        return validate(input: input, regex: ValidationRegex.nik, minLength: 16, maxLength: 16)
    }
}
