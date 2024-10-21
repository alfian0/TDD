//
//  TextValidationError.swift
//  TextValidator
//
//  Created by Alfian on 03/10/24.
//

import Foundation

enum TextValidationError: Error, LocalizedError {
    case EMPTY
    case TOO_SHORT
    case TOO_LONG
    case INVALID_FORMAT
    case CANNOT_SQUENTIAL
    case IDENTICAL_CONSECUTIVE
    case NOT_EQUAL
    case AGE_LIMIT

    var errorDescription: String? {
        switch self {
        case .EMPTY:
            return "Empty"
        case .TOO_SHORT:
            return "Too short"
        case .TOO_LONG:
            return "Too long"
        case .INVALID_FORMAT:
            return "Invalid format"
        case .CANNOT_SQUENTIAL:
            return "Cannot squential"
        case .IDENTICAL_CONSECUTIVE:
            return "Your PIN cannot contain six identical consecutive digits like '111111', '222222', or '333333'. Please choose a more secure PIN."
        case .NOT_EQUAL:
            return "Not Equal"
        case .AGE_LIMIT:
            return "Age Limit"
        }
    }
}
