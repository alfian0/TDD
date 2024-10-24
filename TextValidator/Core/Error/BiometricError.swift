//
//  BiometricError.swift
//  TextValidator
//
//  Created by Alfian on 24/10/24.
//

import Foundation

enum BiometricError: Error, LocalizedError {
    case notAvailable
    case notMatched
    case accessDenied
    case noFaceIDEnrolled
    case noTouchIDEnrolled
    case noOpticIDEnrolled
    case unknown

    var errorDescription: String? {
        switch self {
        case .notAvailable:
            return "Biometric authentication is not available."
        case .notMatched:
            return "The biometric data did not match."
        case .accessDenied:
            return "Access denied. Please check your settings."
        case .noFaceIDEnrolled:
            return "No Face ID is enrolled."
        case .noTouchIDEnrolled:
            return "No Touch ID is enrolled."
        case .noOpticIDEnrolled:
            return "No Optic ID is enrolled."
        case .unknown:
            return "An unknown biometric error occurred."
        }
    }
}
