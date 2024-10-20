//
//  LoginBiometricUsecase.swift
//  TextValidator
//
//  Created by Alfian on 16/10/24.
//

import Foundation

enum LoginBiometricUsecaseError: Error, LocalizedError {
    case NOT_AVAILABLE
    case NOT_MATCHED
    case ACCESS_DENIED
    case NO_FACEID_ENROLLED
    case NO_TOUCHID_ENROLLED
    case NO_OPTICID_ENROLLED
    case UNKNOWN
}

final class LoginBiometricUsecase {
    private let loginRepository: AuthRepository
    private let loginUsecase: LoginUsecase

    init(
        loginRepository: AuthRepository,
        loginUsecase: LoginUsecase
    ) {
        self.loginRepository = loginRepository
        self.loginUsecase = loginUsecase
    }

    func exec() async -> Result<Bool, LoginBiometricUsecaseError> {
        do {
            let user = try await loginRepository.signInWithFaceID()
            return .success(true)
        } catch {
            let error = error as NSError
            switch error.code {
            case -6:
                return .failure(.ACCESS_DENIED)
            case -7:
                switch loginRepository.biometricType() {
                case .none:
                    return .failure(.NOT_AVAILABLE)
                case .face:
                    return .failure(.NO_FACEID_ENROLLED)
                case .touch:
                    return .failure(.NO_TOUCHID_ENROLLED)
                case .optic:
                    return .failure(.NO_OPTICID_ENROLLED)
                }
            default:
                return .failure(.NOT_MATCHED)
            }
        }
    }
}
