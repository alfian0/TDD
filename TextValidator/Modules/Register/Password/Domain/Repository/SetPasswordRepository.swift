//
//  SetPasswordRepository.swift
//  TextValidator
//
//  Created by Alfian on 15/10/24.
//

final class SetPasswordRepository {
    private let service: FirebaseAuthService

    init(service: FirebaseAuthService) {
        self.service = service
    }

    func updatePassword(password: String) async throws {
        try await service.updatePassword(password: password)
    }
}
