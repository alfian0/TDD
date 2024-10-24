//
//  AuthRepository.swift
//  TextValidator
//
//  Created by Alfian on 17/10/24.
//

import Foundation

protocol AuthRepository {
    func signInWithEmail(email: String, password: String) async throws -> UserModel
    func verifyPhoneNumber(phone: String) async throws -> String
    func saveFullname(name: String) async throws -> Bool
    func sendEmailVerification(email: String) async throws
    func verifyCode(verificationID: String, verificationCode: String) async throws -> UserModel
    func updatePassword(password: String) async throws
}
