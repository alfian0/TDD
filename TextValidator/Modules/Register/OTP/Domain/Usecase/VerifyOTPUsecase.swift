//
//  VerifyOTPUsecase.swift
//  TextValidator
//
//  Created by Alfian on 15/10/24.
//

import Foundation

enum VerifyOTPUsecaseError: Error, LocalizedError {
    case UNKNOWN
}

final class VerifyOTPUsecase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func execute(verificationID: String, verificationCode: String) async -> Result<UserModel, VerifyOTPUsecaseError> {
        do {
            let user = try await repository.verifyCode(verificationID: verificationID, verificationCode: verificationCode)
            return .success(user)
        } catch {
            return .failure(.UNKNOWN)
        }
    }
}
