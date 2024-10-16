//
//  RegisterEmailRepository.swift
//  TextValidator
//
//  Created by Alfian on 15/10/24.
//

final class RegisterEmailRepository {
    private let service: FirebaseAuthService

    init(service: FirebaseAuthService) {
        self.service = service
    }

    func sendEmailVerification(email: String) async throws {
        try await service.sendEmailVerification(email: email)
    }

    func reload() async throws -> Bool {
        return try await service.reload()?.isEmailVerified ?? false
    }
}
