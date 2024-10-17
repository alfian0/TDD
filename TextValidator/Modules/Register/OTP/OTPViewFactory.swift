//
//  OTPViewFactory.swift
//  TextValidator
//
//  Created by Alfian on 17/10/24.
//

final class OTPViewFactory {
    private let firebaseAuthService = FirebaseAuthService()

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
        return VerifyOTPUsecase(repository: createVerifyOTPRepository())
    }

    private func createVerifyOTPRepository() -> VerifyOTPRepository {
        return VerifyOTPRepository(service: firebaseAuthService)
    }
}
