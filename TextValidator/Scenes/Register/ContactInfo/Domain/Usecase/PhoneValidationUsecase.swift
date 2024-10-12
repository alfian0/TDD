//
//  PhoneValidationUsecase.swift
//  TextValidator
//
//  Created by Alfian on 03/10/24.
//

import Foundation

final class PhoneValidationUsecase {
	func execute(input: String) -> TextValidationError? {
		let regex = "^\\+[1-9][0-9]{5,15}$"
		let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
		return predicate.evaluate(with: input) ? nil : .INVALID_FORMAT
	}
}
