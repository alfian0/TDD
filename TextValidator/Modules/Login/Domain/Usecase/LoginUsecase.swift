//
//  LoginUsecase.swift
//  TextValidator
//
//  Created by Alfian on 15/10/24.
//

import Foundation
import Swinject

class LoginUsecaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LoginUsecase.self) { r in
            guard let repository = r.resolve(AuthRepositoryImpl.self) else {
                fatalError()
            }
            guard let emailValidationUsecase = r.resolve(EmailValidationUsecase.self) else {
                fatalError()
            }
            return LoginUsecase(repository: repository, emailValidationUsecase: emailValidationUsecase)
        }
    }
}

// MARK: Usecase just single bussiness logic, validate, or conver data or error to new mapper

enum LoginUsecaseError: Error, LocalizedError {
    case INVALID_EMAIL(TextValidationError)
    case ERROR_INVALID_CREDENTIAL
    case UNKNOWN
}

final class LoginUsecase {
    private let repository: AuthRepository
    private let emailValidationUsecase: EmailValidationUsecase

    init(
        repository: AuthRepository,
        emailValidationUsecase: EmailValidationUsecase
    ) {
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
