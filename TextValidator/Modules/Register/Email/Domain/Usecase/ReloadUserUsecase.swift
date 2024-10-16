//
//  ReloadUserUsecase.swift
//  TextValidator
//
//  Created by Alfian on 16/10/24.
//

import Foundation

enum ReloadUserUsecaseError: Error, LocalizedError {
    case EMPTY
    case UNKNOWN
}

final class ReloadUserUsecase {
    private let repository: RegisterEmailRepository

    init(repository: RegisterEmailRepository) {
        self.repository = repository
    }

    func execute() async -> Result<Bool, ReloadUserUsecaseError> {
        do {
            let isEmailVerified = try await repository.reload()
            return .success(isEmailVerified)
        } catch {
            return .failure(.UNKNOWN)
        }
    }
}
