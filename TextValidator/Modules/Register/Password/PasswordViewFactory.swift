//
//  PasswordViewFactory.swift
//  TextValidator
//
//  Created by Alfian on 17/10/24.
//

final class PasswordViewFactory {
    private let passwordStrengthUsecase = PasswordStrengthUsecase()
    private let firebaseAuthService = FirebaseAuthService()

    @MainActor
    func createPasswordViewModel(coordinator: PasswordCoordinator) -> PasswordViewModel {
        return PasswordViewModel(
            setPasswordUsecase: createSetPasswordUsecase(),
            passwordStrengthUsecase: passwordStrengthUsecase,
            coordinator: coordinator
        )
    }

    private func createSetPasswordUsecase() -> SetPasswordUsecase {
        return SetPasswordUsecase(repository: createAuthRepository())
    }

    private func createAuthRepository() -> AuthRepository {
        return AuthRepositoryImpl(service: firebaseAuthService)
    }
}
