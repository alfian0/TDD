//
//  RegisterEmailUsecase.swift
//  TextValidator
//
//  Created by Alfian on 15/10/24.
//

import Foundation

enum RegisterEmailUsecaseError: Error, LocalizedError {
    case INVALID_EMAIL(TextValidationError)
    case ERROR_UNAUTHORIZED_DOMAIN
    case ERROR_INVALID_CONTINUE_URI
    case UNKNOWN
}

final class RegisterEmailUsecase {
    private let repository: AuthRepository
    private let emailValidationUsecase: EmailValidationUsecase

    init(
        repository: AuthRepository,
        emailValidationUsecase: EmailValidationUsecase
    ) {
        self.repository = repository
        self.emailValidationUsecase = emailValidationUsecase
    }

    func execute(email: String) async -> Result<Void, RegisterEmailUsecaseError> {
        if let error = emailValidationUsecase.execute(input: email) {
            return .failure(.INVALID_EMAIL(error))
        }

        do {
            try await repository.sendEmailVerification(email: email)
            return .success(())
        } catch {
            return .failure(.UNKNOWN)
        }
    }
}
