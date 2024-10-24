//
//  AuthRepositoryImpl.swift
//  TextValidator
//
//  Created by Alfian on 17/10/24.
//

import Foundation

final class AuthRepositoryImpl: AuthRepository {
    private let firebaseAuthService: FirebaseAuthService

    init(
        firebaseAuthService: FirebaseAuthService
    ) {
        self.firebaseAuthService = firebaseAuthService
    }

    func signInWithEmail(email: String, password: String) async throws -> UserModel {
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
}
