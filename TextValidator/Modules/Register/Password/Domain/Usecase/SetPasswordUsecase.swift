//
//  SetPasswordUsecase.swift
//  TextValidator
//
//  Created by Alfian on 14/10/24.
//

import Combine
import Foundation

enum SetPasswordUsecaseError: Error, LocalizedError {
    case unknown
}

final class SetPasswordUsecase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func execute(password: String) async -> Result<Void, SetPasswordUsecaseError> {
        do {
            try await repository.updatePassword(password: password)
            return .success(())
        } catch {
            return .failure(.unknown)
        }
    }
}
