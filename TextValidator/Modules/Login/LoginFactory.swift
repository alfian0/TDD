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
        let repository = createLoginRepository()
        let loginUsecase = createLoginUsecase(repository: repository)
        let loginBiometricUsecase = createLoginBiometricUsecase(repository: repository, loginUsecase: loginUsecase)

        return LoginViewModel(
            loginUsecase: loginUsecase,
            loginBiometricUsecase: loginBiometricUsecase,
            emailValidationUsecase: emailValidationUsecase,
            coordinator: coordinator,
            didDismiss: didDismiss
        )
    }

    private func createLoginRepository() -> LoginRepository {
        return LoginRepositoryImpl(
            authService: firebaseAuthService,
            biometricService: biometricService,
            keychainService: keychainService,
            userdefaultsService: userdefaultsService
        )
    }

    private func createLoginUsecase(repository: LoginRepository) -> LoginUsecase {
        return LoginUsecase(
            repository: repository,
            emailValidationUsecase: emailValidationUsecase
        )
    }

    private func createLoginBiometricUsecase(repository: LoginRepository, loginUsecase: LoginUsecase) -> LoginBiometricUsecase {
        return LoginBiometricUsecase(
            repository: repository,
            loginUsecase: loginUsecase
        )
    }
}
