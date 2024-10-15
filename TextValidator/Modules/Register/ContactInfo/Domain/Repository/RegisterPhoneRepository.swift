//
//  RegisterPhoneRepository.swift
//  TextValidator
//
//  Created by Alfian on 15/10/24.
//

final class RegisterPhoneRepository {
    private let service: FirebaseRegisterService

    init(service: FirebaseRegisterService) {
        self.service = service
    }

    func verifyPhoneNumber(phone: String) async throws -> String {
        try await service.verifyPhoneNumber(phone: phone)
    }

    func saveFullname(name: String) async throws -> Bool {
        try await service.saveFullname(name: name)
    }
}
