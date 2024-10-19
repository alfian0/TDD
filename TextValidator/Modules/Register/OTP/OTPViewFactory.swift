//
//  OTPViewFactory.swift
//  TextValidator
//
//  Created by Alfian on 17/10/24.
//

final class OTPViewFactory {
    private let firebaseAuthService = FirebaseAuthService()
    private let biometricService = BiometricService()

    @MainActor
    func createOTPViewModel(
        type: OTPType,
        verificationID: String,
        coordinator: OTPCoordinator,
        didSuccess: @escaping () -> Void
    ) -> OTPViewModel {
        return OTPViewModel(
            type: type,
            verificationID: verificationID,
            verifyOTPUsecase: createVerifyOTPUsecase(),
            coordinator: coordinator,
            didSuccess: didSuccess
        )
    }

    private func createVerifyOTPUsecase() -> VerifyOTPUsecase {
        return VerifyOTPUsecase(repository: createAuthRepository())
    }

    private func createAuthRepository() -> AuthRepository {
        return AuthRepositoryImpl(
            firebaseAuthService: firebaseAuthService,
            biometricService: biometricService
        )
    }
}
