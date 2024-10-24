//
//  LoginBiometricUsecase.swift
//  TextValidator
//
//  Created by Alfian on 16/10/24.
//

import Foundation

final class LoginBiometricUsecase {
    private let loginRepository: AuthRepository
    private let biometricService: BiometricService
    private let keychainService: KeychainService
    private let loginUsecase: LoginUsecase

    init(
        loginRepository: AuthRepository,
        biometricService: BiometricService,
        keychainService: KeychainService,
        loginUsecase: LoginUsecase
    ) {
        self.loginRepository = loginRepository
        self.biometricService = biometricService
        self.keychainService = keychainService
        self.loginUsecase = loginUsecase
    }

    func exec() async -> Result<UserModel, LoginUsecaseError> {
        do {
            // MARK: Check if biometric is avilable

            let isBiometricAvailable = try biometricService.isBiometricAvailable()
            guard isBiometricAvailable else {
                return .failure(.biometric(.notAvailable))
            }

            // MARK: Check is biometric authentication success

            let isAuthenticated = try await biometricService.authenticateWithBiometrics()
            guard isAuthenticated else {
                return .failure(.biometric(.notMatched))
            }

            // MARK: Get email, password or token to login

            keychainService.getToken()

            // MARK: LogIn with fetched value

            let result = await loginUsecase.exec(email: "", password: "")
            guard case let .success(success) = result else {
                if case let .failure(failure) = result {
                    return .failure(failure)
                }
                return .failure(.unknown)
            }

            return .success(success)
        } catch {
            let error = error as NSError
            switch error.code {
            case -7:
                switch biometricService.biometricType() {
                case .none:
                    return .failure(.biometric(.notAvailable))
                case .faceID:
                    return .failure(.biometric(.noFaceIDEnrolled))
                case .touchID:
                    return .failure(.biometric(.noTouchIDEnrolled))
                case .opticID:
                    return .failure(.biometric(.noOpticIDEnrolled))
                @unknown default:
                    return .failure(.biometric(.notMatched))
                }
            default:
                return .failure(.biometric(.notMatched))
            }
        }
    }
}
