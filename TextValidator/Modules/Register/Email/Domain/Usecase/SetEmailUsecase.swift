//
//  SetEmailUsecase.swift
//  TextValidator
//
//  Created by Alfian on 14/10/24.
//

import Combine
import Foundation

enum SetEmailError: String, Error, LocalizedError {
    case ERROR_UNAUTHORIZED_DOMAIN
    case ERROR_INVALID_CONTINUE_URI
    case UNKNOWN
}

final class SetEmailUsecase {
    private let service: EmailRepository

    init(service: EmailRepository) {
        self.service = service
    }

    func execute(email: String) -> AnyPublisher<Void, SetEmailError> {
        service.sendEmailVerification(email: email)
            .catch { error -> AnyPublisher<Void, SetEmailError> in
                let error = error as NSError
                if let userInfo = error.userInfo as? [String: String],
                   let key = userInfo["FIRAuthErrorUserInfoNameKey"]
                {
                    return Fail(error: SetEmailError(rawValue: key) ?? .UNKNOWN)
                        .eraseToAnyPublisher()
                }
                return Fail(error: SetEmailError.UNKNOWN)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
