//
//  LoginFactory.swift
//  TextValidator
//
//  Created by Alfian on 17/10/24.
//

final class LoginFactory {
    private let firebaseAuthService = FirebaseAuthService()
    private let biometricService = BiometricService()
    private let keychainService = KeychainService()
    private let userdefaultsService = UserdefaultsService()
    private let emailValidationUsecase = EmailValidationUsecase()

    @MainActor
    func createLoginViewModel(
        didDismiss: @escaping () -> Void,
        coordinator: LoginViewCoordinator
    ) -> LoginViewModel {
        let loginRepository = createAuthRepository()
        let loginUsecase = createLoginUsecase(repository: loginRepository)
        let loginBiometricUsecase = createLoginBiometricUsecase(
            loginRepository: loginRepository,
            loginUsecase: loginUsecase
        )

        return LoginViewModel(
            loginUsecase: loginUsecase,
            loginBiometricUsecase: loginBiometricUsecase,
            emailValidationUsecase: emailValidationUsecase,
            coordinator: coordinator,
            didDismiss: didDismiss
        )
    }

    private func createAuthRepository() -> AuthRepository {
        return AuthRepositoryImpl(firebaseAuthService: firebaseAuthService, biometricService: biometricService)
    }

    private func createLoginUsecase(repository: AuthRepository) -> LoginUsecase {
        return LoginUsecase(
            repository: repository,
            emailValidationUsecase: emailValidationUsecase
        )
    }

    private func createLoginBiometricUsecase(
        loginRepository: AuthRepository,
        loginUsecase: LoginUsecase
    ) -> LoginBiometricUsecase {
        return LoginBiometricUsecase(
            loginRepository: loginRepository,
            loginUsecase: loginUsecase
        )
    }
}
