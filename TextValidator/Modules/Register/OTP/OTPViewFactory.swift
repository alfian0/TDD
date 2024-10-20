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
        title: String,
        subtitle: String,
        count: Int,
        duration: Int,
        coordinator: OTPCoordinator,
        didResend: @escaping () -> Void,
        didChange: @escaping () -> Void,
        didSuccess: @escaping (String) -> Void
    ) -> OTPViewModel {
        return OTPViewModel(
            title: title,
            subtitle: subtitle,
            count: count,
            duration: duration,
            coordinator: coordinator,
            didResend: didResend,
            didChange: didChange,
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
