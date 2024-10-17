//
//  LoginBiometricUsecase.swift
//  TextValidator
//
//  Created by Alfian on 16/10/24.
//

import Foundation

enum LoginBiometricUsecaseError: Error, LocalizedError {
    case NOT_AVAILABLE
    case ACCESS_DENIED
    case NO_FACEID_ENROLLED
    case NO_TOUCHID_ENROLLED
    case UNKNOWN
}

final class LoginBiometricUsecase {
    private let repository: LoginRepository
    private let loginUsecase: LoginUsecase

    init(
        repository: LoginRepository,
        loginUsecase: LoginUsecase
    ) {
        self.repository = repository
        self.loginUsecase = loginUsecase
    }

    func exec() async -> Result<Bool, LoginBiometricUsecaseError> {
        do {
            let isBiometricAvailable = try await repository.isBiometricAvailable()

            guard isBiometricAvailable else {
                return .failure(.NOT_AVAILABLE)
            }

            let authencticated = try await repository.authenticateWithBiometrics()

            // To Do: Get email or password to login
            // To Do: Use login usecase to login with saved email and password
//            await loginUsecase.exec(email: "", password: "")
            return .success(authencticated)
        } catch {
            let error = error as NSError
            switch error.code {
            case -6:
                return .failure(.ACCESS_DENIED)
            case -7:
                if repository.biometricType() == .face {
                    return .failure(.NO_FACEID_ENROLLED)
                } else if repository.biometricType() == .touch {
                    return .failure(.NO_TOUCHID_ENROLLED)
                } else {
                    return .failure(.UNKNOWN)
                }
            default:
                return .failure(.UNKNOWN)
            }
        }
    }
}
