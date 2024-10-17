//
//  VerificationEmailUsecase.swift
//  TextValidator
//
//  Created by Alfian on 17/10/24.
//

import Foundation

enum VerificationEmailUsecaseError: Error, LocalizedError {
    case UNKNOWN
}

final class VerificationEmailUsecase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func execute(link: String) async -> Result<UserModel, VerificationEmailUsecaseError> {
        guard let urlComponents = URLComponents(string: link) else {
            return .failure(.UNKNOWN)
        }
        guard let continueUrl = urlComponents.queryItems?.filter({ $0.name == "continueUrl" }).first?.value else {
            return .failure(.UNKNOWN)
        }
        guard let urlComponents = URLComponents(string: continueUrl) else {
            return .failure(.UNKNOWN)
        }
        guard let email = urlComponents.queryItems?.filter({ $0.name == "email" }).first?.value else {
            return .failure(.UNKNOWN)
        }

        do {
            let user = try await repository.signInWithEmail(email: email, link: link)
            return .success(user)
        } catch {
            return .failure(.UNKNOWN)
        }
    }
}
