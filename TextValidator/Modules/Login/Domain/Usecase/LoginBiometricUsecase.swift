//
//  LoginBiometricUsecase.swift
//  TextValidator
//
//  Created by Alfian on 16/10/24.
//

import Foundation

enum LoginBiometricUsecaseError: Error, LocalizedError {
    case NOT_AVAILABLE
    case UNKNOWN
}

final class LoginBiometricUsecase {
    private let service: BiometricService

    init(service: BiometricService) {
        self.service = service
    }

    func exec() async -> Result<Bool, LoginBiometricUsecaseError> {
        do {
            let isBiometricAvailable = try service.isBiometricAvailable()
            guard isBiometricAvailable else {
                return .failure(.NOT_AVAILABLE)
            }
            let authencticated = try await service.authenticateWithBiometrics()

            // To Do: Get email or password to login
            // To Do: Use login usecase to login with saved email and password
            return .success(authencticated)
        } catch {
            return .failure(.UNKNOWN)
        }
    }
}
