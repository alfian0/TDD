//
//  LoginRepository.swift
//  TextValidator
//
//  Created by Alfian on 15/10/24.
//

import Foundation

// MARK: Repository use service but not importing Third-patry and Handling multiple source

// MARK: For this case use FirebaseLoginService and UserDefault to temporary save email

protocol LoginRepository {
    func signInWithEmail(email: String, password: String) async throws -> UserModel
    func isBiometricAvailable() async throws -> Bool
    func biometricType() -> BiometricType
    func authenticateWithBiometrics() async throws -> Bool
}

final class LoginRepositoryImpl: LoginRepository {
    private let authService: FirebaseAuthService
    private let biometricService: BiometricService
    private let keychainService: KeychainService
    private let userdefaultsService: UserdefaultsService

    init(
        authService: FirebaseAuthService,
        biometricService: BiometricService,
        keychainService: KeychainService,
        userdefaultsService: UserdefaultsService
    ) {
        self.authService = authService
        self.biometricService = biometricService
        self.keychainService = keychainService
        self.userdefaultsService = userdefaultsService
    }

    func signInWithEmail(email: String, password: String) async throws -> UserModel {
        let user = try await authService.signInWithEmail(email: email, password: password)

        return UserMapper.map(user: user)
    }

    func sendSignInLink(email: String) async throws {
        try await authService.sendSignInLink(email: email)
        userdefaultsService.saveEmail(email)
    }

    func signInWithEmail(link: String) async throws -> UserModel {
        guard let email = userdefaultsService.getEmail() else {
            throw NSError(domain: "login.repository", code: 0)
        }

        let authDataResult = try await authService.signInWithEmail(email: email, link: link)

        guard authDataResult.user.emailVerified() else {
            throw NSError(domain: "login.repository", code: 0)
        }

        userdefaultsService.removeEmail()

        return UserMapper.map(user: authDataResult.user)
    }

    func isBiometricAvailable() async throws -> Bool {
        try biometricService.isBiometricAvailable()
    }

    func biometricType() -> BiometricType {
        switch biometricService.biometricType() {
        case .none:
            return .none
        case .faceID:
            return .face
        case .touchID:
            return .touch
        case .opticID:
            return .optic
        @unknown default:
            return .none
        }
    }

    func authenticateWithBiometrics() async throws -> Bool {
        try await biometricService.authenticateWithBiometrics()
    }
}
