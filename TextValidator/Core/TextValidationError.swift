//
//  TextValidationError.swift
//  TextValidator
//
//  Created by Alfian on 03/10/24.
//

import Foundation

enum TextValidationError: Error, LocalizedError {
    case empty
    case tooShort
    case tooLong
    case invalidFormat
    case cannotSequential
    case identicalConsecutive
    case notEqual
    case ageLimit

    var errorDescription: String? {
        switch self {
        case .empty:
            return "The field cannot be empty."
        case .tooShort:
            return "The input is too short."
        case .tooLong:
            return "The input is too long."
        case .invalidFormat:
            return "The input format is invalid."
        case .cannotSequential:
            return "The input cannot be sequential."
        case .identicalConsecutive:
            return "Your PIN cannot contain six identical consecutive digits."
        case .notEqual:
            return "The inputs do not match."
        case .ageLimit:
            return "The age limit is not met."
        }
    }
}
