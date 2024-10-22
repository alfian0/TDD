//
//  SetPasswordUsecase.swift
//  TextValidator
//
//  Created by Alfian on 14/10/24.
//

import Combine
import Foundation
import Swinject

class SetPasswordUsecaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SetPasswordUsecase.self) { r in
            guard let repository = r.resolve(AuthRepositoryImpl.self) else {
                fatalError()
            }
            return SetPasswordUsecase(repository: repository)
        }
    }
}

enum SetPasswordUsecaseError: Error, LocalizedError {
    case UNKNOWN
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
            return .failure(.UNKNOWN)
        }
    }
}
