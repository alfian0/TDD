//
//  FirebaseAuthService.swift
//  TextValidator
//
//  Created by Alfian on 15/10/24.
//

import FirebaseAuth

final class FirebaseAuthService {
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
        try await Auth.auth().currentUser?.sendEmailVerification(beforeUpdatingEmail: email)
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
}
