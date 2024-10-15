//
//  DefaultCheckContactInfoService.swift
//  TextValidator
//
//  Created by Alfian on 07/10/24.
//

import Combine
import FirebaseAuth
import Foundation

final class DefaultCheckContactInfoService: CheckContactInfoRepository {
    func verify(phone: String) -> AnyPublisher<String, any Error> {
        Auth.auth().settings?.isAppVerificationDisabledForTesting = false
        return Future<String, any Error> { promise in
            PhoneAuthProvider.provider().verifyPhoneNumber(phone) { verificationID, error in
                if let error = error {
                    promise(.failure(error))
                } else if let verificationID = verificationID {
                    promise(.success(verificationID))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func update(fullname: String) -> AnyPublisher<User?, any Error> {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = fullname
        return Future<User?, any Error> { promise in
            changeRequest?.commitChanges(completion: { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(Auth.auth().currentUser))
                }
            })
        }
        .eraseToAnyPublisher()
    }
}
