//
//  EmailViewFactory.swift
//  TextValidator
//
//  Created by Alfian on 17/10/24.
//

final class EmailViewFactory {
    private let firebaseAuthService = FirebaseAuthService()
    private let emailValidationUsecase = EmailValidationUsecase()

    @MainActor
    func createEmailViewModel(viewState: EmailViewState, coordinator: EmailCoordinator) -> EmailViewModel {
        return EmailViewModel(
            viewState: viewState,
            emailValidationUsecase: emailValidationUsecase,
            registerEmailUsecase: createRegisterEmailUsecase(),
            reloadUserUsecase: createReloadUserUsecase(),
            coordinator: coordinator
        )
    }

    private func createRegisterEmailUsecase() -> RegisterEmailUsecase {
        return RegisterEmailUsecase(
            repository: createRegisterEmailRepository(),
            emailValidationUsecase: emailValidationUsecase
        )
    }

    private func createReloadUserUsecase() -> ReloadUserUsecase {
        return ReloadUserUsecase(repository: createRegisterEmailRepository())
    }

    private func createRegisterEmailRepository() -> RegisterEmailRepository {
        return RegisterEmailRepository(service: firebaseAuthService)
    }
}
