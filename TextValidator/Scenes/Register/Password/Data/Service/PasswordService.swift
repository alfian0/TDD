//
//  PasswordService.swift
//  TextValidator
//
//  Created by Alfian on 14/10/24.
//

import Combine
import FirebaseAuth

final class PasswordService: PasswordRepository {
    func update(password: String) -> AnyPublisher<User?, any Error> {
        return Future<User?, any Error> { promise in
            Auth.auth().currentUser?.updatePassword(to: password, completion: { error in
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
