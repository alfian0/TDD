//
//  EmailService.swift
//  TextValidator
//
//  Created by Alfian on 14/10/24.
//

import Combine
import FirebaseAuth

final class EmailService: EmailRepository {
    func sendEmailVerification(email: String) -> AnyPublisher<Void, Error> {
        return Future<Void, any Error> { promise in
            let actionCodeSettings = ActionCodeSettings()
            actionCodeSettings.handleCodeInApp = true
            actionCodeSettings.url = URL(string: "https://textvalidator-fddd6.firebaseapp.com")
            Auth.auth().currentUser?.sendEmailVerification(
                beforeUpdatingEmail: email,
                actionCodeSettings: actionCodeSettings,
                completion: { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
            )
        }
        .eraseToAnyPublisher()
    }
}
