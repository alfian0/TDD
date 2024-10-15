//
//  RegisterEmailRepository.swift
//  TextValidator
//
//  Created by Alfian on 15/10/24.
//

final class RegisterEmailRepository {
    private let service: FirebaseRegisterService

    init(service: FirebaseRegisterService) {
        self.service = service
    }

    func sendEmailVerification(email: String) async throws {
        try await service.sendEmailVerification(email: email)
    }
}
