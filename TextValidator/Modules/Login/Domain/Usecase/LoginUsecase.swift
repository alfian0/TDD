//
//  LoginUsecase.swift
//  TextValidator
//
//  Created by Alfian on 15/10/24.
//

import Foundation

// MARK: Usecase just single bussiness logic, validate, or conver data or error to new mapper

enum LoginUsecaseError: Error, LocalizedError {
    case invalidEmail(TextValidationError)
    case biometric(BiometricError)
    case network(NetworkError)
    case unknown
}

final class LoginUsecase {
    private let repository: AuthRepository
    private let networkMonitorService: NetworkMonitorService
    private let emailValidationUsecase: EmailValidationUsecase

    init(
        repository: AuthRepository,
        networkMonitorService: NetworkMonitorService,
        emailValidationUsecase: EmailValidationUsecase
    ) {
        self.repository = repository
        self.networkMonitorService = networkMonitorService
        self.emailValidationUsecase = emailValidationUsecase
    }

    func exec(email: String, password: String) async -> Result<UserModel, LoginUsecaseError> {
        if let error = emailValidationUsecase.execute(input: email) {
            return .failure(.invalidEmail(error))
        }

        do {
            // MARK: Check if connected to internet

            let isConnected = try await networkMonitorService.isConnected()
            guard isConnected else {
                return .failure(.network(.offline))
            }

            // MARK: SignIn with email and password

            let user = try await repository.signInWithEmail(email: email, password: password)
            return .success(user)
        } catch {
            return .failure(.unknown)
        }
    }
}
