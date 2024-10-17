//
//  ContactInfoFactory.swift
//  TextValidator
//
//  Created by Alfian on 17/10/24.
//

final class ContactInfoFactory {
    private let nameValidationUsecase = NameValidationUsecase()
    private let phoneValidationUsecase = PhoneValidationUsecase()
    private let defaultCountryCodeService = DefaultCountryCodeService()
    private let firebaseAuthService = FirebaseAuthService()

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

    private func createRegisterPhoneRepository() -> RegisterPhoneRepository {
        return RegisterPhoneRepository(service: firebaseAuthService)
    }

    private func createSaveNameUsecase() -> SaveNameUsecase {
        return SaveNameUsecase(
            repository: createRegisterPhoneRepository(),
            nameValidationUsecase: nameValidationUsecase
        )
    }

    private func createRegisterPhoneUsecase() -> RegisterPhoneUsecase {
        return RegisterPhoneUsecase(
            repository: createRegisterPhoneRepository(),
            phoneValidationUsecase: phoneValidationUsecase
        )
    }

    private func createCountryCodeUsecase() -> CountryCodeUsecase {
        return CountryCodeUsecase(service: defaultCountryCodeService)
    }
}
