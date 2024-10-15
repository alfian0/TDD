//
//  RegisterPhoneUsecase.swift
//  TextValidator
//
//  Created by Alfian on 15/10/24.
//

import Foundation

enum RegisterPhoneUsecaseError: Error, LocalizedError {
    case INVALID_PHONE(TextValidationError)
    case UNKNOWN
}

final class RegisterPhoneUsecase {
    private let repository: RegisterPhoneRepository
    private let phoneValidationUsecase: PhoneValidationUsecase

    init(
        repository: RegisterPhoneRepository,
        phoneValidationUsecase: PhoneValidationUsecase
    ) {
        self.repository = repository
        self.phoneValidationUsecase = phoneValidationUsecase
    }

    func execute(phone: String) async -> Result<String, RegisterPhoneUsecaseError> {
        if let error = phoneValidationUsecase.execute(input: phone) {
            return .failure(.INVALID_PHONE(error))
        }

        do {
            let verificationID = try await repository.verifyPhoneNumber(phone: phone)
            return .success(verificationID)
        } catch {
            return .failure(.UNKNOWN)
        }
    }
}
