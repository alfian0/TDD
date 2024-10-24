//
//  ValidationHelper.swift
//  TextValidator
//
//  Created by Alfian on 22/10/24.
//

import Foundation

// Constants for regex patterns
enum ValidationRegex {
    static let email = "^(?:[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*" +
        "|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]" +
        "|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+" +
        "[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?|" +
        "\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}" +
        "(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-zA-Z0-9-]*[a-zA-Z0-9]:" +
        "(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]" +
        "|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
    static let phone = "^\\+[1-9][0-9]{5,15}$"
    static let nik = "^((1[1-9])|(21)|([37][1-6])|(5[1-4])|(6[1-5])|([8-9][1-2]))[0-9]{2}[0-9]{2}(([0-6][0-9])|(7[0-1]))((0[1-9])|(1[0-2]))([0-9]{2})[0-9]{4}$"
    static let name = "^[A-Za-z .,]{3,20}$"
}

// Common validation helper
enum ValidationHelper {
    static func validateEmpty(_ input: String) -> TextValidationError? {
        return input.isEmpty ? .empty : nil
    }

    static func validateLength(_ input: String, min: Int, max: Int) -> TextValidationError? {
        if input.count < min { return .tooShort }
        if input.count > max { return .tooLong }
        return nil
    }

    static func validateRegex(_ input: String, regex: String) -> TextValidationError? {
        return input.regex(with: regex) ? nil : .invalidFormat
    }
}

// Base class to reuse validation logic
class BaseValidationUsecase {
    func validate(input: String, regex: String, minLength: Int, maxLength: Int) -> TextValidationError? {
        if let emptyError = ValidationHelper.validateEmpty(input) {
            return emptyError
        }
        if let lengthError = ValidationHelper.validateLength(input, min: minLength, max: maxLength) {
            return lengthError
        }
        return ValidationHelper.validateRegex(input, regex: regex)
    }
}
