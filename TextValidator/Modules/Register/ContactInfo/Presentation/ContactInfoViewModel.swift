//
//  ContactInfoViewModel.swift
//  TextValidator
//
//  Created by Alfian on 02/10/24.
//

import Combine
import Foundation

@MainActor
final class ContactInfoViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var fullname: String = ""
    @Published var fullnameError: String?
    @Published var phone: String = ""
    @Published var phoneError: String?
    @Published var canSubmit: Bool = false
    @Published var isAgreeToTnC: Bool = false
    @Published var countryCode: CountryCodeModel = .dummy
    @Published var countryCodes: [CountryCodeModel] = []

    private let nameValidationUsecase: NameValidationUsecase
    private let phoneValidationUsecase: PhoneValidationUsecase
    private let countryCodeUsecase: CountryCodeUsecase
    private let registerPhoneUsecase: RegisterPhoneUsecase
    private let saveNameUsecase: SaveNameUsecase
    private let verifyOTPUsecase: VerifyOTPUsecase
    private let coordinator: any ContactInfoCoordinator
    private var verificationID: String = ""
    private let didTapLogin: () -> Void
    var cancellables = Set<AnyCancellable>()

    init(
        nameValidationUsecase: NameValidationUsecase,
        phoneValidationUsecase: PhoneValidationUsecase,
        countryCodeUsecase: CountryCodeUsecase,
        registerPhoneUsecase: RegisterPhoneUsecase,
        saveNameUsecase: SaveNameUsecase,
        verifyOTPUsecase: VerifyOTPUsecase,
        coordinator: any ContactInfoCoordinator,
        didTapLogin: @escaping () -> Void
    ) {
        self.nameValidationUsecase = nameValidationUsecase
        self.phoneValidationUsecase = phoneValidationUsecase
        self.countryCodeUsecase = countryCodeUsecase
        self.registerPhoneUsecase = registerPhoneUsecase
        self.saveNameUsecase = saveNameUsecase
        self.verifyOTPUsecase = verifyOTPUsecase
        self.coordinator = coordinator
        self.didTapLogin = didTapLogin

        bindValidation()
    }

    private func bindValidation() {
        // Handle fullname validation
        $fullname
            .dropFirst()
            .removeDuplicates()
            .map(nameValidationUsecase.execute)
            .map { $0?.localizedDescription }
            .assign(to: &$fullnameError)

        // Handle phone validation with country code
        Publishers.CombineLatest($countryCode, $phone)
            .map { $0.dialCode + $1 }
            .dropFirst()
            .removeDuplicates()
            .map(phoneValidationUsecase.execute)
            .map { $0?.localizedDescription }
            .assign(to: &$phoneError)

        // Combine validity checks for submission
        Publishers.CombineLatest3($fullnameError, $phoneError, $isAgreeToTnC)
            .map { [weak self] fullnameError, phoneError, isAgreeToTnC in
                guard let self = self else { return false }
                return fullnameError == nil && phoneError == nil && isAgreeToTnC && !self.fullname.isEmpty && !self.phone.isEmpty
            }
            .assign(to: \.canSubmit, on: self)
            .store(in: &cancellables)
    }

    func didTapCountryCode() {
        Task {
            if !countryCodes.isEmpty {
                await presentCountryCodeSelection()
            } else {
                await fetchCountryCodes()
            }
        }
    }

    func didTapContinue() {
        registerPhone()
    }

    func launchLogin() {
        didTapLogin()
    }

    func cancel() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }

    private func registerPhone() {
        Task {
            updateLoadingState(true)
            defer { updateLoadingState(false) }

            let result = await registerPhoneUsecase.execute(phone: countryCode.dialCode + phone)
            guard case let .success(verificationID) = result else {
                if case let .failure(error) = result {
                    await handleError(error)
                }
                return
            }
            self.verificationID = verificationID
            await showOTPVerificationScreen()
        }
    }

    private func presentCountryCodeSelection() async {
        await coordinator.present(.countryCode(
            selected: countryCode,
            items: countryCodes,
            onSelect: { [weak self] selectedCode in
                self?.countryCode = selectedCode
            },
            onDismiss: {}
        ))
    }

    private func fetchCountryCodes() async {
        updateLoadingState(true)
        defer { updateLoadingState(false) }

        let result = await countryCodeUsecase.execute()
        switch result {
        case let .success(countries):
            countryCodes = countries
            await presentCountryCodeSelection()
        case let .failure(error):
            await handleError(error)
        }
    }

    private func showOTPVerificationScreen() async {
        await coordinator.push(.otp(
            title: "Verify your phone number",
            subtitle: "Enter the OTP code sent to \(countryCode.dialCode)\(phone)",
            count: 6,
            duration: 10,
            onResendTapped: { [weak self] in
                self?.resendOTP()
            },
            onOTPChanged: {},
            onOTPSuccess: { [weak self] otp in
                self?.validateOTP(otp: otp)
            }
        ))
    }

    private func resendOTP() {
        registerPhone() // Reuse the registerPhone function
    }

    private func validateOTP(otp: String) {
        Task {
            updateLoadingState(true)
            defer { updateLoadingState(false) }

            let otpResult = await verifyOTPUsecase.execute(verificationID: verificationID, verificationCode: otp)
            guard case .success = otpResult else {
                if case let .failure(error) = otpResult {
                    await handleError(error)
                }
                return
            }

            let nameResult = await saveNameUsecase.execute(name: fullname)
            guard case let .success(isEmailVerified) = nameResult else {
                if case let .failure(error) = nameResult {
                    await handleError(error)
                }
                return
            }

            await proceedAfterValidation(isEmailVerified: isEmailVerified)
        }
    }

    private func proceedAfterValidation(isEmailVerified: Bool) async {
        if isEmailVerified {
            await coordinator.push(.password)
        } else {
            await coordinator.push(.email)
        }
    }

    private func handleError(_ error: Error) async {
        await coordinator.present(.error(title: "Error", subtitle: error.localizedDescription, onDismiss: {}))
    }

    private func updateLoadingState(_ isLoading: Bool) {
        self.isLoading = isLoading
    }
}
