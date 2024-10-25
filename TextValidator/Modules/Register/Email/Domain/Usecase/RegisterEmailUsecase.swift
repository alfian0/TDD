//
//  RegisterEmailUsecase.swift
//  TextValidator
//
//  Created by Alfian on 15/10/24.
//

import Foundation

enum RegisterEmailUsecaseError: Error, LocalizedError {
    case invalidEmail(TextValidationError)
    case unauthorizeDomain
    case invalidURI
    case unknown
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
            return .failure(.invalidEmail(error))
        }

        do {
            try await repository.sendEmailVerification(email: email)
            return .success(())
        } catch {
            print(error, error.localizedDescription)
            return .failure(.unknown)
        }
    }
}
