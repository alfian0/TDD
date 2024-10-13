//
//  OTPVerifyUsecase.swift
//  TextValidator
//
//  Created by Alfian on 13/10/24.
//

import Combine
import FirebaseAuth

enum OTPVerifyError: Error, LocalizedError {
    case NOT_MATCH
    case UNKNOWN

    var errorDescription: String? {
        switch self {
        case .NOT_MATCH:
            return "OTP not match"
        case .UNKNOWN:
            return "Unknown"
        }
    }
}

protocol OTPVerifyUsecase {
    func execute(verificationID: String, verificationCode: String) -> AnyPublisher<AuthDataResult, OTPVerifyError>
}

final class DefaultOTPVerifyUsecase: OTPVerifyUsecase {
    private let service: OTPVerifyRepository

    init(service: OTPVerifyRepository) {
        self.service = service
    }

    func execute(verificationID: String, verificationCode: String) -> AnyPublisher<FirebaseAuth.AuthDataResult, OTPVerifyError> {
        service.execute(verificationID: verificationID, verificationCode: verificationCode)
            .catch { error -> AnyPublisher<FirebaseAuth.AuthDataResult, OTPVerifyError> in
                let error = error as NSError
                if let userInfo = error.userInfo as? [String: String],
                   userInfo["FIRAuthErrorUserInfoNameKey"] == "ERROR_INVALID_VERIFICATION_CODE"
                {
                    return Fail(error: OTPVerifyError.NOT_MATCH)
                        .eraseToAnyPublisher()
                }
                return Fail(error: OTPVerifyError.UNKNOWN)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
