//
//  EmailViewFactory.swift
//  TextValidator
//
//  Created by Alfian on 17/10/24.
//

final class EmailViewFactory {
    private let firebaseAuthService = FirebaseAuthService()
    private let biometricService = BiometricService()
    private let emailValidationUsecase = EmailValidationUsecase()

    @MainActor
    func createEmailViewModel(viewState: EmailViewState, coordinator: EmailCoordinator) -> EmailViewModel {
        return EmailViewModel(
            viewState: viewState,
            emailValidationUsecase: emailValidationUsecase,
            registerEmailUsecase: createRegisterEmailUsecase(),
            reloadUserUsecase: createReloadUserUsecase(),
            verificationEmailUsecase: createVerificationEmailUsecase(),
            coordinator: coordinator
        )
    }

    private func createRegisterEmailUsecase() -> RegisterEmailUsecase {
        return RegisterEmailUsecase(
            repository: createAuthRepository(),
            emailValidationUsecase: emailValidationUsecase
        )
    }

    private func createReloadUserUsecase() -> ReloadUserUsecase {
        return ReloadUserUsecase(repository: createAuthRepository())
    }

    private func createAuthRepository() -> AuthRepository {
        return AuthRepositoryImpl(firebaseAuthService: firebaseAuthService, biometricService: biometricService)
    }

    private func createVerificationEmailUsecase() -> VerificationEmailUsecase {
        return VerificationEmailUsecase(repository: createAuthRepository())
    }
}
