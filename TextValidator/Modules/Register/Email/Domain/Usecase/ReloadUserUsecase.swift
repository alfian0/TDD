//
//  ReloadUserUsecase.swift
//  TextValidator
//
//  Created by Alfian on 16/10/24.
//

import Foundation
import Swinject

class ReloadUserUsecaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ReloadUserUsecase.self) { r in
            guard let repository = r.resolve(AuthRepositoryImpl.self) else {
                fatalError()
            }
            return ReloadUserUsecase(repository: repository)
        }
    }
}

enum ReloadUserUsecaseError: Error, LocalizedError {
    case EMPTY
    case UNKNOWN
}

final class ReloadUserUsecase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func execute() async -> Result<Bool, ReloadUserUsecaseError> {
//        do {
//            let isEmailVerified = try await repository.reload()
//            return .success(isEmailVerified)
//        } catch {
        return .failure(.UNKNOWN)
//        }
    }
}
