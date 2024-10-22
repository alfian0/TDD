//
//  AppAssembler.swift
//  TextValidator
//
//  Created by Alfian on 22/10/24.
//

import Swinject

@MainActor
final class AppAssembler {
    private init() {}
    static let shared: Assembler = .init([
        VisionRepositoryImplAssembly(),
        CountryCodeRepositoryImplAssembly(),
        AuthRepositoryImplAssembly(),
        VisionServiceAssembly(),
        UserdefaultsServiceAssembly(),
        BiometricServiceAssembly(),
        KeychainServiceAssembly(),
        FirebaseAuthServiceAssembly(),
        CameraServiceAssembly(),
        ExtractKTPUsecaseAssembly(),
        ExtractNIKUsecaseAssembly(),
        ExtractDOBUsecaseAssembly(),
        ExtractNationalityTypeUsecaseAssembly(),
        ExtractJobTypeUsecaseAssembly(),
        ExtractReligionTypeUsecaseAssembly(),
        ExtractMaritalStatusUsecaseAssembly(),
        ExtractGenderUsecaseAssembly(),
        AgeValidationUsecaseAssembly(),
        NIKValidationUsecaseAssembly(),
        NameValidationUsecaseAssembly(),
        PINValidationUsecaseAssembly(),
        EmailValidationUsecaseAssembly(),
        PhoneValidationUsecaseAssembly(),
        LoginViewCoordinatorAssembly(),
        LoginBiometricUsecaseAssembly(),
        LoginUsecaseAssembly(),
        LoginViewModelAssembly(),
        LoginViewAssembly(),
        OCRViewCoordinatorAssembly(),
        OCRViewModelAssembly(),
        OCRViewAssembly(),
        ContactInfoCoordinatorDeeplinkAssembly(),
        ContactInfoCoordinatorAssembly(),
        SaveNameUsecaseAssembly(),
        RegisterPhoneUsecaseAssembly(),
        VerifyOTPUsecaseAssembly(),
        ContactInfoViewModelAssembly(),
        ContactInfoViewAssembly(),
        CountryCodeUsecaseAssembly(),
        FilterCountryCodesUsecaseAssembly(),
        CountryCodeViewModelAssembly(),
        CountrySearchListViewAssembly(),
        CountryCodeCoordinatorAssembly(),
        EmailCoordinatorImplAssembly(),
        EmailCoordinatorDeeplinkAssembly(),
        VerificationEmailUsecaseAssembly(),
        ReloadUserUsecaseAssembly(),
        RegisterEmailUsecaseAssembly(),
        EmailViewModelAssembly(),
        EmailViewAssembly(),
        OTPCoordinatorAssembly(),
        OTPViewModelAssembly(),
        OTPViewAssembly(),
        PasswordCoordinatorAssembly(),
        SetPasswordUsecaseAssembly(),
        PasswordStrengthUsecaseAssembly(),
        PasswordViewModelAssembly(),
        PasswordViewAssembly(),
    ])
}
