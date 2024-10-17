//
//  AuthRepositoryImpl.swift
//  TextValidator
//
//  Created by Alfian on 17/10/24.
//

import Foundation

final class AuthRepositoryImpl: AuthRepository {
    private let service: FirebaseAuthService

    init(service: FirebaseAuthService) {
        self.service = service
    }

    func signInWithEmail(email: String, password: String) async throws -> UserModel {
        let user = try await service.signInWithEmail(email: email, password: password)

        return UserMapper.map(user: user)
    }

    func sendSignInLink(email: String) async throws {
        try await service.sendSignInLink(email: email)
    }

    func signInWithEmail(email: String, link: String) async throws -> UserModel {
        let authDataResult = try await service.signInWithEmail(email: email, link: link)

        guard authDataResult.user.emailVerified() else {
            throw NSError(domain: "login.repository", code: 0)
        }

        return UserMapper.map(user: authDataResult.user)
    }

    func verifyPhoneNumber(phone: String) async throws -> String {
        try await service.verifyPhoneNumber(phone: phone)
    }

    func saveFullname(name: String) async throws -> Bool {
        try await service.saveFullname(name: name)
    }

    func sendEmailVerification(email: String) async throws {
        try await service.sendEmailVerification(email: email)
    }

    func reload() async throws -> Bool {
        return try await service.reload()?.isEmailVerified ?? false
    }

    func verifyCode(verificationID: String, verificationCode: String) async throws -> UserModel {
        let result = try await service.verifyCode(
            verificationID: verificationID,
            verificationCode: verificationCode
        )
        return UserMapper.map(user: result.user)
    }

    func updatePassword(password: String) async throws {
        try await service.updatePassword(password: password)
    }
}
