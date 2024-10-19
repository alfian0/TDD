//
//  AuthRepositoryImpl.swift
//  TextValidator
//
//  Created by Alfian on 17/10/24.
//

import Foundation

final class AuthRepositoryImpl: AuthRepository {
    private let firebaseAuthService: FirebaseAuthService
    private let biometricService: BiometricService

    init(
        firebaseAuthService: FirebaseAuthService,
        biometricService: BiometricService
    ) {
        self.firebaseAuthService = firebaseAuthService
        self.biometricService = biometricService
    }

    func signInWithEmail(email: String, password: String) async throws -> UserModel {
        let user = try await firebaseAuthService.signInWithEmail(email: email, password: password)

        return UserMapper.map(user: user)
    }

    func sendSignInLink(email: String) async throws {
        try await firebaseAuthService.sendSignInLink(email: email)
    }

    func signInWithEmail(email: String, link: String) async throws -> UserModel {
        let authDataResult = try await firebaseAuthService.signInWithEmail(email: email, link: link)

        guard authDataResult.user.emailVerified() else {
            throw NSError(domain: "login.repository", code: 0)
        }

        return UserMapper.map(user: authDataResult.user)
    }

    func verifyPhoneNumber(phone: String) async throws -> String {
        try await firebaseAuthService.verifyPhoneNumber(phone: phone)
    }

    func saveFullname(name: String) async throws -> Bool {
        try await firebaseAuthService.saveFullname(name: name)
    }

    func sendEmailVerification(email: String) async throws {
        try await firebaseAuthService.sendEmailVerification(email: email)
    }

    func reload() async throws -> Bool {
        return try await firebaseAuthService.reload()?.isEmailVerified ?? false
    }

    func verifyCode(verificationID: String, verificationCode: String) async throws -> UserModel {
        let result = try await firebaseAuthService.verifyCode(
            verificationID: verificationID,
            verificationCode: verificationCode
        )
        return UserMapper.map(user: result.user)
    }

    func updatePassword(password: String) async throws {
        try await firebaseAuthService.updatePassword(password: password)
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
