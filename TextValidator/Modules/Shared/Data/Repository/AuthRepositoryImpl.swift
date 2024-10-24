//
//  AuthRepositoryImpl.swift
//  TextValidator
//
//  Created by Alfian on 17/10/24.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case offline

    var errorDescription: String? {
        switch self {
        case .offline:
            return "No Internet Connection"
        }
    }
}

enum AuthRepositoryError: Error, LocalizedError {
    case biometric(BiometricError)
    case network(NetworkError)

    var errorDescription: String? {
        switch self {
        case let .biometric(error):
            return error.localizedDescription
        case let .network(error):
            return error.localizedDescription
        }
    }
}

final class AuthRepositoryImpl: AuthRepository {
    private let firebaseAuthService: FirebaseAuthService
    private let biometricService: BiometricService
    private let networkMonitorService: NetworkMonitorService

    init(
        firebaseAuthService: FirebaseAuthService,
        biometricService: BiometricService,
        networkMonitorService: NetworkMonitorService
    ) {
        self.firebaseAuthService = firebaseAuthService
        self.biometricService = biometricService
        self.networkMonitorService = networkMonitorService
    }

    func signInWithEmail(email: String, password: String) async throws -> UserModel {
        let isConnected = try await networkMonitorService.isConnected()
        guard isConnected else {
            throw AuthRepositoryError.network(.offline)
        }
        let user = try await firebaseAuthService.signInWithEmail(email: email, password: password)

        return UserMapper.map(user: user)
    }

    func signInWithFaceID() async throws -> UserModel {
        let isBiometricAvailable = try biometricService.isBiometricAvailable()
        guard isBiometricAvailable else {
            throw AuthRepositoryError.biometric(.notAvailable)
        }
        let isAuthenticated = try await biometricService.authenticateWithBiometrics()
        guard isAuthenticated else {
            throw AuthRepositoryError.biometric(.notMatched)
        }
        // To Do: Get email and password from keychain
        let email = ""
        let password = ""
        let user = try await firebaseAuthService.signInWithEmail(email: email, password: password)
        return UserMapper.map(user: user)
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
}
