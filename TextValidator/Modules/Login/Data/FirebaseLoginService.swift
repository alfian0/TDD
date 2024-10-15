//
//  FirebaseLoginService.swift
//  TextValidator
//
//  Created by Alfian on 15/10/24.
//

import FirebaseAuth

// MARK: Service related to Third-party in this case FirebaseAuth

final class FirebaseLoginService {
    func signInWithEmail(email: String, password: String) async throws -> User {
        try await Auth.auth().signIn(withEmail: email, password: password).user
    }

    func sendSignInLink(email: String) async throws {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.url = URL(string: "")
        try await Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings)
    }

    func signInWithEmail(email: String, link: String) async throws -> AuthDataResult {
        try await Auth.auth().signIn(withEmail: email, link: link)
    }
}
