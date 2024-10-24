//
//  SaveNameUsecase.swift
//  TextValidator
//
//  Created by Alfian on 15/10/24.
//

import Foundation

enum SaveNameUsecaseError: Error, LocalizedError {
    case invalidName(TextValidationError)
    case unknown
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
            return .failure(.invalidName(error))
        }

        do {
            let isEmailVerified = try await repository.saveFullname(name: name)
            return .success(isEmailVerified)
        } catch {
            return .failure(.unknown)
        }
    }
}
