//
//  SetPasswordUsecase.swift
//  TextValidator
//
//  Created by Alfian on 14/10/24.
//

import Combine
import Foundation

enum SetPassword: Error, LocalizedError {
    case UNKNOWN
}

final class SetPasswordUsecase {
    private let service: PasswordRepository

    init(service: PasswordRepository) {
        self.service = service
    }

    func execute(password: String) -> AnyPublisher<UserModel, SetPassword> {
        service.update(password: password)
            .compactMap { $0 }
            .map { UserMapper.map(user: $0) }
            .catch { _ in
                Fail(error: SetPassword.UNKNOWN)
            }
            .eraseToAnyPublisher()
    }
}
