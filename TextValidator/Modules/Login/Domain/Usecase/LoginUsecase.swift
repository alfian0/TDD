//
//  LoginUsecase.swift
//  TextValidator
//
//  Created by Alfian on 15/10/24.
//

import Foundation

// MARK: Usecase just single bussiness logic, validate, or conver data or error to new mapper

enum LoginUsecaseError: Error, LocalizedError {
    case INVALID_EMAIL(TextValidationError)
    case ERROR_INVALID_CREDENTIAL
    case UNKNOWN
}

final class LoginUsecase {
    private let repository: LoginRepository
    private let emailValidationUsecase: EmailValidationUsecase

    init(repository: LoginRepository, emailValidationUsecase: EmailValidationUsecase) {
        self.repository = repository
        self.emailValidationUsecase = emailValidationUsecase
    }

    func exec(email: String, password: String) async -> Result<UserModel, LoginUsecaseError> {
        if let error = emailValidationUsecase.execute(input: email) {
            return .failure(.INVALID_EMAIL(error))
        }

        do {
            let user = try await repository.signInWithEmail(email: email, password: password)
            return .success(user)
        } catch {
            return .failure(.UNKNOWN)
        }
    }
}
