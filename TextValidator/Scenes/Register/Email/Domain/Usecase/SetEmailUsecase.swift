//
//  SetEmailUsecase.swift
//  TextValidator
//
//  Created by Alfian on 14/10/24.
//

import Combine
import Foundation

enum SetEmailError: Error, LocalizedError {
    case UNKNOWN
}

final class SetEmailUsecase {
    private let service: EmailRepository

    init(service: EmailRepository) {
        self.service = service
    }

    func execute(email: String) -> AnyPublisher<Void, SetEmailError> {
        service.execute(email: email)
            .catch { error in
                Fail(error: SetEmailError.UNKNOWN)
            }
            .eraseToAnyPublisher()
    }
}
