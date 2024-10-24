//
//  UseCaseAssembler.swift
//  TextValidator
//
//  Created by Alfian on 22/10/24.
//

import Swinject

final class UseCaseAssembler: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(LoginBiometricUsecase.self) { r in
            guard let loginRepository = r.resolve(AuthRepositoryImpl.self) else {
                fatalError()
            }
            guard let loginUsecase = r.resolve(LoginUsecase.self) else {
                fatalError()
            }
            guard let biometricService = r.resolve(BiometricService.self) else {
                fatalError()
            }
            guard let keychainService = r.resolve(KeychainService.self) else {
                fatalError()
            }
            return LoginBiometricUsecase(
                loginRepository: loginRepository,
                biometricService: biometricService,
                keychainService: keychainService,
                loginUsecase: loginUsecase
            )
        }

        container.register(LoginUsecase.self) { r in
            guard let repository = r.resolve(AuthRepositoryImpl.self) else {
                fatalError()
            }
            guard let networkMonitorService = r.resolve(NetworkMonitorService.self) else {
                fatalError()
            }
            guard let emailValidationUsecase = r.resolve(EmailValidationUsecase.self) else {
                fatalError()
            }
            return LoginUsecase(
                repository: repository,
                networkMonitorService: networkMonitorService,
                emailValidationUsecase: emailValidationUsecase
            )
        }

        container.register(SaveNameUsecase.self) { r in
            guard let repository = r.resolve(AuthRepositoryImpl.self) else {
                fatalError()
            }
            guard let nameValidationUsecase = r.resolve(NameValidationUsecase.self) else {
                fatalError()
            }
            return SaveNameUsecase(repository: repository, nameValidationUsecase: nameValidationUsecase)
        }

        container.register(RegisterPhoneUsecase.self) { r in
            guard let repository = r.resolve(AuthRepositoryImpl.self) else {
                fatalError()
            }
            guard let phoneValidationUsecase = r.resolve(PhoneValidationUsecase.self) else {
                fatalError()
            }
            return RegisterPhoneUsecase(repository: repository, phoneValidationUsecase: phoneValidationUsecase)
        }

        container.register(VerifyOTPUsecase.self) { r in
            guard let repository = r.resolve(AuthRepositoryImpl.self) else {
                fatalError()
            }
            return VerifyOTPUsecase(repository: repository)
        }

        container.register(CountryCodeUsecase.self) { r in
            guard let repository = r.resolve(CountryCodeRepositoryImpl.self) else {
                fatalError()
            }
            return CountryCodeUsecase(repository: repository)
        }

        container.register(FilterCountryCodesUsecase.self) { _ in
            FilterCountryCodesUsecase()
        }

        container.register(VerificationEmailUsecase.self) { r in
            guard let repository = r.resolve(AuthRepositoryImpl.self) else {
                fatalError()
            }
            return VerificationEmailUsecase(repository: repository)
        }

        container.register(ReloadUserUsecase.self) { r in
            guard let repository = r.resolve(AuthRepositoryImpl.self) else {
                fatalError()
            }
            return ReloadUserUsecase(repository: repository)
        }

        container.register(RegisterEmailUsecase.self) { r in
            guard let repository = r.resolve(AuthRepositoryImpl.self) else {
                fatalError()
            }
            guard let emailValidationUsecase = r.resolve(EmailValidationUsecase.self) else {
                fatalError()
            }
            return RegisterEmailUsecase(repository: repository, emailValidationUsecase: emailValidationUsecase)
        }

        container.register(SetPasswordUsecase.self) { r in
            guard let repository = r.resolve(AuthRepositoryImpl.self) else {
                fatalError()
            }
            return SetPasswordUsecase(repository: repository)
        }

        container.register(PasswordStrengthUsecase.self) { _ in
            PasswordStrengthUsecase()
        }
    }
}
