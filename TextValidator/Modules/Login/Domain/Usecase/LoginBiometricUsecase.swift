//
//  LoginBiometricUsecase.swift
//  TextValidator
//
//  Created by Alfian on 16/10/24.
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

final class LoginBiometricUsecase {
    private let loginRepository: AuthRepository
    private let loginUsecase: LoginUsecase

    init(
        loginRepository: AuthRepository,
        loginUsecase: LoginUsecase
    ) {
        self.loginRepository = loginRepository
        self.loginUsecase = loginUsecase
    }

    func exec() async -> Result<Bool, BiometricError> {
        do {
            let user = try await loginRepository.signInWithFaceID()
            return .success(true)
        } catch {
            let error = error as NSError
            return .failure(mapBiometricError(from: error))
        }
    }

    func mapBiometricError(from error: NSError) -> BiometricError {
        switch error.code {
        case -7:
            switch loginRepository.biometricType() {
            case .none:
                return .notAvailable
            case .face:
                return .noFaceIDEnrolled
            case .touch:
                return .noTouchIDEnrolled
            case .optic:
                return .noOpticIDEnrolled
            }
        default:
            return .notMatched
        }
    }
}
