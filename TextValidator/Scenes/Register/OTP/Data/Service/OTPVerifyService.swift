//
//  OTPVerifyService.swift
//  TextValidator
//
//  Created by Alfian on 13/10/24.
//

import Combine
import FirebaseAuth

final class OTPVerifyService: OTPVerifyRepository {
    func execute(verificationID: String, verificationCode: String) -> AnyPublisher<AuthDataResult, any Error> {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        return Future<AuthDataResult, any Error> { promise in
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print(error)
                    promise(.failure(error))
                } else if let authResult = authResult {
                    promise(.success(authResult))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
