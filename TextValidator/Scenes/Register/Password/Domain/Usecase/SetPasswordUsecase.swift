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
            .map {
                UserModel(
                    providerID: $0?.providerID ?? "",
                    uid: $0?.uid ?? "",
                    displayName: $0?.displayName,
                    photoURL: $0?.photoURL,
                    email: $0?.email,
                    phoneNumber: $0?.email
                )
            }
            .catch { _ in
                Fail(error: SetPassword.UNKNOWN)
            }
            .eraseToAnyPublisher()
    }
}
