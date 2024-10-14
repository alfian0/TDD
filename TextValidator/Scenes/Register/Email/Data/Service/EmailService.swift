//
//  EmailService.swift
//  TextValidator
//
//  Created by Alfian on 14/10/24.
//

import Combine
import FirebaseAuth

final class EmailService: EmailRepository {
    func execute(email: String) -> AnyPublisher<Void, Error> {
        return Future<Void, any Error> { promise in
            Auth.auth().currentUser?.sendEmailVerification(beforeUpdatingEmail: email, completion: { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            })
        }
        .eraseToAnyPublisher()
    }
}
