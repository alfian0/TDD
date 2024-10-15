//
//  LoginRepository.swift
//  TextValidator
//
//  Created by Alfian on 15/10/24.
//

import Foundation

// MARK: Repository use service but not importing Third-patry and Handling multiple source
// MARK: For this case use FirebaseLoginService and UserDefault to temporary save email
protocol LoginRepository {
    func signInWithEmail(email: String, password: String) async throws -> UserModel
}

// MARK: TO DO remove this to Constant
let emailLogin = "email_login"

final class LoginRepositoryImpl: LoginRepository {
    private let service: FirebaseLoginService

    init(service: FirebaseLoginService) {
        self.service = service
    }

    func signInWithEmail(email: String, password: String) async throws -> UserModel {
        let user = try await service.signInWithEmail(email: email, password: password)

        return UserMapper.map(user: user)
    }

    func sendSignInLink(email: String) async throws {
        try await service.sendSignInLink(email: email)
        UserDefaults.standard.set(email, forKey: emailLogin)
    }

    func signInWithEmail(link: String) async throws -> UserModel {
        guard let email = UserDefaults.standard.string(forKey: emailLogin) else {
            throw NSError(domain: "login.repository", code: 0)
        }

        let authDataResult = try await service.signInWithEmail(email: email, link: link)

        guard authDataResult.user.emailVerified() else {
            throw NSError(domain: "login.repository", code: 0)
        }
        
        UserDefaults.standard.removeObject(forKey: emailLogin)

        return UserMapper.map(user: authDataResult.user)
    }
}
