//
//  ContactInfoFactory.swift
//  TextValidator
//
//  Created by Alfian on 17/10/24.
//

final class ContactInfoFactory {
    private let nameValidationUsecase = NameValidationUsecase()
    private let phoneValidationUsecase = PhoneValidationUsecase()
    private let countryCodeRepository = CountryCodeRepositoryImpl()
    private let firebaseAuthService = FirebaseAuthService()
    private let biometricService = BiometricService()

    @MainActor
    func createContactInfoViewModel(
        didTapLogin: @escaping () -> Void,
        coordinator: ContactInfoCoordinator
    ) -> ContactInfoViewModel {
        return ContactInfoViewModel(
            fullnameValidationUsecase: nameValidationUsecase,
            phoneValidationUsecase: phoneValidationUsecase,
            countryCodeUsecase: createCountryCodeUsecase(),
            registerPhoneUsecase: createRegisterPhoneUsecase(),
            saveNameUsecase: createSaveNameUsecase(),
            coordinator: coordinator,
            didTapLogin: didTapLogin
        )
    }

    private func createAuthRepository() -> AuthRepository {
        return AuthRepositoryImpl(
            firebaseAuthService: firebaseAuthService,
            biometricService: biometricService
        )
    }

    private func createSaveNameUsecase() -> SaveNameUsecase {
        return SaveNameUsecase(
            repository: createAuthRepository(),
            nameValidationUsecase: nameValidationUsecase
        )
    }

    private func createRegisterPhoneUsecase() -> RegisterPhoneUsecase {
        return RegisterPhoneUsecase(
            repository: createAuthRepository(),
            phoneValidationUsecase: phoneValidationUsecase
        )
    }

    private func createCountryCodeUsecase() -> CountryCodeUsecase {
        return CountryCodeUsecase(repository: countryCodeRepository)
    }
}
