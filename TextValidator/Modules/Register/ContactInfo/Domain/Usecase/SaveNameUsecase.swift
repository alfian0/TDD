//
//  SaveNameUsecase.swift
//  TextValidator
//
//  Created by Alfian on 15/10/24.
//

import Foundation
import Swinject

class SaveNameUsecaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SaveNameUsecase.self) { r in
            guard let repository = r.resolve(AuthRepositoryImpl.self) else {
                fatalError()
            }
            guard let nameValidationUsecase = r.resolve(NameValidationUsecase.self) else {
                fatalError()
            }
            return SaveNameUsecase(repository: repository, nameValidationUsecase: nameValidationUsecase)
        }
    }
}

enum SaveNameUsecaseError: Error, LocalizedError {
    case INVALID_NAME(TextValidationError)
    case UNKNOWN
}

final class SaveNameUsecase {
    private let repository: AuthRepository
    private let nameValidationUsecase: NameValidationUsecase

    init(
        repository: AuthRepository,
        nameValidationUsecase: NameValidationUsecase
    ) {
        self.repository = repository
        self.nameValidationUsecase = nameValidationUsecase
    }

    func execute(name: String) async -> Result<Bool, SaveNameUsecaseError> {
        if let error = nameValidationUsecase.execute(input: name) {
            return .failure(.INVALID_NAME(error))
        }

        do {
            let isEmailVerified = try await repository.saveFullname(name: name)
            return .success(isEmailVerified)
        } catch {
            return .failure(.UNKNOWN)
        }
    }
}
