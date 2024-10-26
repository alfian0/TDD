//
//  FirebaseAuthService.swift
//  TextValidator
//
//  Created by Alfian on 15/10/24.
//

import FirebaseAuth

final class FirebaseAuthService {
    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?

    func signInWithEmail(email: String, password: String) async throws -> User {
        try await Auth.auth().signIn(withEmail: email, password: password).user
    }

    func signInWithEmail(email: String, link: String) async throws -> AuthDataResult {
        try await Auth.auth().signIn(withEmail: email, link: link)
    }

    func verifyPhoneNumber(phone: String) async throws -> String {
        Auth.auth().settings?.isAppVerificationDisabledForTesting = false
        return try await PhoneAuthProvider.provider().verifyPhoneNumber(phone)
    }

    func saveFullname(name: String) async throws -> Bool {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        try await changeRequest?.commitChanges()
        return Auth.auth().currentUser?.isEmailVerified ?? false
    }

    func sendEmailVerification(email: String) async throws {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://textvalidator.page.link/AvmB")
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier ?? "")
        try await Auth.auth().currentUser?.sendEmailVerification(beforeUpdatingEmail: email, actionCodeSettings: actionCodeSettings)
    }

    func reload() async throws -> User? {
        try await Auth.auth().currentUser?.reload()
        return Auth.auth().currentUser
    }

    func verifyCode(verificationID: String, verificationCode: String) async throws -> AuthDataResult {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        return try await Auth.auth().signIn(with: credential)
    }

    func updatePassword(password: String) async throws {
        try await Auth.auth().currentUser?.updatePassword(to: password)
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    func authStateChangeStream() -> AsyncStream<User?> {
        AsyncStream { continuation in
            let handle = Auth.auth().addStateDidChangeListener { _, user in
                continuation.yield(user)
            }

            continuation.onTermination = { _ in
                Auth.auth().removeStateDidChangeListener(handle)
            }
        }
    }
}
