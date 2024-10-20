//
//  ContactInfoViewModel.swift
//  TextValidator
//
//  Created by Alfian on 02/10/24.
//

import Combine
import Foundation
import Swinject

@MainActor
class ContactInfoViewModelAssembly: @preconcurrency Assembly {
    func assemble(container: Container) {
        container.register(ContactInfoViewModel.self) { (r, c: ContactInfoCoordinatorImpl, d: @escaping (() -> Void)) in
            guard let nameValidationUsecase = r.resolve(NameValidationUsecase.self) else {
                fatalError()
            }
            guard let phoneValidationUsecase = r.resolve(PhoneValidationUsecase.self) else {
                fatalError()
            }
            guard let countryCodeUsecase = r.resolve(CountryCodeUsecase.self) else {
                fatalError()
            }
            guard let registerPhoneUsecase = r.resolve(RegisterPhoneUsecase.self) else {
                fatalError()
            }
            guard let saveNameUsecase = r.resolve(SaveNameUsecase.self) else {
                fatalError()
            }
            guard let verifyOTPUsecase = r.resolve(VerifyOTPUsecase.self) else {
                fatalError()
            }
            return ContactInfoViewModel(
                nameValidationUsecase: nameValidationUsecase,
                phoneValidationUsecase: phoneValidationUsecase,
                countryCodeUsecase: countryCodeUsecase,
                registerPhoneUsecase: registerPhoneUsecase,
                saveNameUsecase: saveNameUsecase,
                verifyOTPUsecase: verifyOTPUsecase,
                coordinator: c,
                didTapLogin: d
            )
        }
    }
}

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
    private var coordinator: any ContactInfoCoordinator

    private var verificationID: String = ""

    var cancellables = Set<AnyCancellable>()
    let didTapLogin: () -> Void

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

        $fullname
            .dropFirst()
            .removeDuplicates()
            .map(nameValidationUsecase.execute)
            .map { $0?.localizedDescription }
            .assign(to: &$fullnameError)

        Publishers.CombineLatest($countryCode, $phone)
            .map { countryCode, phone in
                countryCode.dialCode + phone
            }
            .dropFirst()
            .removeDuplicates()
            .map(phoneValidationUsecase.execute)
            .map { $0?.localizedDescription }
            .assign(to: &$phoneError)

        Publishers.CombineLatest3($fullnameError, $phoneError, $isAgreeToTnC)
            .map { [weak self] emailError, passwordError, isAgreeToTnC in
                guard let self = self else { return false }
                return emailError == nil && passwordError == nil && isAgreeToTnC && !self.fullname.isEmpty && !self.phone.isEmpty
            }
            .assign(to: \.canSubmit, on: self)
            .store(in: &cancellables)
    }

    func didTapCountryCode() async {
        if !countryCodes.isEmpty {
            await launchCountryCode()
        } else {
            isLoading = true

            defer {
                isLoading = false
            }

            let result = await countryCodeUsecase.execute()
            switch result {
            case let .success(countries):
                countryCodes = countries
                await launchCountryCode()
            case let .failure(error):
                await coordinator.present(.error(title: "Error", subtitle: error.localizedDescription, didDismiss: {}))
            }
        }
    }

    func didTapCountinue() async {
        isLoading = true

        defer {
            isLoading = false
        }

        let result = await registerPhoneUsecase.execute(phone: countryCode.dialCode + phone)
        guard case let .success(verificationID) = result else {
            if case let .failure(error) = result {
                await coordinator.present(.error(title: "Error", subtitle: error.localizedDescription, didDismiss: {}))
            }
            return
        }

        self.verificationID = verificationID
        await coordinator.push(.otp(
            title: "Verify your phone number",
            subtitle: "Enter the 5-digit OTP code sent to \(countryCode.dialCode)\(phone)",
            count: 6,
            duration: 10,
            didResend: { [weak self] in
                Task {
                    guard let self = self else { return }
                    let result = await self.registerPhoneUsecase.execute(phone: self.countryCode.dialCode + self.phone)
                    guard case let .success(verificationID) = result else {
                        if case let .failure(error) = result {
                            await self.coordinator.present(.error(title: "Error", subtitle: error.localizedDescription, didDismiss: {}))
                        }
                        return
                    }
                    self.verificationID = verificationID
                }
            },
            didChange: {
                print("didchange")
            },
            didSuccess: { [weak self] otp in
                Task {
                    await self?.validate(with: otp)
                }
            }
        ))
    }

    func launchLogin() {
        didTapLogin()
    }

    func launchCountryCode() async {
        await coordinator.present(.countryCode(selected: countryCode, items: countryCodes, didSelect: { [weak self] item in
            self?.countryCode = item
        }, didDismiss: {}))
    }

    func cancel() {
        for cancellable in cancellables {
            cancellable.cancel()
        }
        cancellables.removeAll()
    }

    private func validate(with otp: String) async {
        isLoading = true

        defer {
            isLoading = false
        }

        let result2 = await verifyOTPUsecase.execute(verificationID: verificationID, verificationCode: otp)
        guard case let .success(user) = result2 else {
            if case let .failure(error) = result2 {
                await coordinator.present(.error(title: "Error", subtitle: error.localizedDescription, didDismiss: {}))
            }
            return
        }

        let result3 = await saveNameUsecase.execute(name: fullname)
        guard case let .success(isEmailVerified) = result3 else {
            if case let .failure(error) = result3 {
                await coordinator.present(.error(title: "Error", subtitle: error.localizedDescription, didDismiss: {}))
            }
            return
        }

        if isEmailVerified {
            await coordinator.push(.password)
        } else {
            await coordinator.push(.email)
        }
    }
}
