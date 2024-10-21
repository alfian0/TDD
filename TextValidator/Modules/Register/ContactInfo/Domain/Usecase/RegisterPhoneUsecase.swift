//
//  RegisterPhoneUsecase.swift
//  TextValidator
//
//  Created by Alfian on 15/10/24.
//

import Foundation
import Swinject

class RegisterPhoneUsecaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(RegisterPhoneUsecase.self) { r in
            guard let repository = r.resolve(AuthRepositoryImpl.self) else {
                fatalError()
            }
            guard let phoneValidationUsecase = r.resolve(PhoneValidationUsecase.self) else {
                fatalError()
            }
            return RegisterPhoneUsecase(repository: repository, phoneValidationUsecase: phoneValidationUsecase)
        }
    }
}

enum RegisterPhoneUsecaseError: Error, LocalizedError {
    case INVALID_PHONE(TextValidationError)
    case UNKNOWN
}

final class RegisterPhoneUsecase {
    private let repository: AuthRepository
    private let phoneValidationUsecase: PhoneValidationUsecase

    init(
        repository: AuthRepository,
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
