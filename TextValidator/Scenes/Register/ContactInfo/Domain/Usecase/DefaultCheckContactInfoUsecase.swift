//
//  DefaultCheckContactInfoUsecase.swift
//  TextValidator
//
//  Created by Alfian on 07/10/24.
//

import Combine
import Foundation

enum ContactInfoError: Error, LocalizedError, Equatable {
    case ALREADY_REGISTERED
    case ERROR_INVALID_PHONE_NUMBER
    case UNKNOWN

    var errorDescription: String? {
        switch self {
        case .ALREADY_REGISTERED:
            return "Already registered"
        case .ERROR_INVALID_PHONE_NUMBER:
            return "Invalid Phone Number"
        case .UNKNOWN:
            return "Unknown"
        }
    }
}

protocol CheckContactInfoUsecase {
    func verify(fullname: String, phone: String) -> AnyPublisher<String, ContactInfoError>
    func update(fullname: String) -> AnyPublisher<UserModel, ContactInfoError>
}

final class DefaultCheckContactInfoUsecase: CheckContactInfoUsecase {
    private let service: CheckContactInfoRepository

    init(service: CheckContactInfoRepository) {
        self.service = service
    }

    func verify(fullname _: String, phone: String) -> AnyPublisher<String, ContactInfoError> {
        service.verify(phone: phone)
            .catch { error -> AnyPublisher<String, ContactInfoError> in
                let error = error as NSError
                if let userInfo = error.userInfo as? [String: String],
                   userInfo["FIRAuthErrorUserInfoNameKey"] == "ERROR_INVALID_PHONE_NUMBER"
                {
                    return Fail(error: ContactInfoError.ERROR_INVALID_PHONE_NUMBER)
                        .eraseToAnyPublisher()
                }
                return Fail(error: ContactInfoError.UNKNOWN)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func update(fullname: String) -> AnyPublisher<UserModel, ContactInfoError> {
        service.update(fullname: fullname)
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
            .catch { error -> AnyPublisher<UserModel, ContactInfoError> in
                Fail(error: ContactInfoError.UNKNOWN)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
