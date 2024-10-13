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
    case NETWORK_ERROR(Error)
    case UNKNOWN

    static func == (lhs: ContactInfoError, rhs: ContactInfoError) -> Bool {
        switch (lhs, rhs) {
        case (.ALREADY_REGISTERED, .ALREADY_REGISTERED):
            return true
        case let (.NETWORK_ERROR(lhsError), .NETWORK_ERROR(rhsError)):
            return (lhsError as NSError).domain == (rhsError as NSError).domain &&
                (lhsError as NSError).code == (rhsError as NSError).code
        case (.UNKNOWN, .UNKNOWN):
            return true
        default:
            return false
        }
    }

    var errorDescription: String? {
        switch self {
        case .ALREADY_REGISTERED:
            return "Already registered"
        case .ERROR_INVALID_PHONE_NUMBER:
            return "Invalid Phone Number"
        case let .NETWORK_ERROR(error):
            return error.localizedDescription
        case .UNKNOWN:
            return "Unknown"
        }
    }
}

protocol CheckContactInfoUsecase {
    func execute(fullname: String, phone: String) -> AnyPublisher<String, ContactInfoError>
}

final class DefaultCheckContactInfoUsecase: CheckContactInfoUsecase {
    private let service: CheckContactInfoRepository

    init(service: CheckContactInfoRepository) {
        self.service = service
    }

    func execute(fullname: String, phone: String) -> AnyPublisher<String, ContactInfoError> {
        return service.execute(fullname: fullname, phone: phone)
            .catch { error -> AnyPublisher<String, ContactInfoError> in
                let error = error as NSError
                if let userInfo = error.userInfo as? [String: String],
                   userInfo["FIRAuthErrorUserInfoNameKey"] == "ERROR_INVALID_PHONE_NUMBER"
                {
                    return Fail(error: ContactInfoError.ERROR_INVALID_PHONE_NUMBER)
                        .eraseToAnyPublisher()
                }
                return Fail(error: ContactInfoError.NETWORK_ERROR(error))
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
