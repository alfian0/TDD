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

    private let fullnameValidationUsecase: NameValidationUsecase
    private let phoneValidationUsecase: PhoneValidationUsecase
    private let countryCodeUsecase: CountryCodeUsecase
    private let registerPhoneUsecase: RegisterPhoneUsecase
    private let saveNameUsecase: SaveNameUsecase
    private var coordinator: any ContactInfoCoordinator

    var cancellables = Set<AnyCancellable>()
    let didTapLogin: () -> Void

    init(
        fullnameValidationUsecase: NameValidationUsecase,
        phoneValidationUsecase: PhoneValidationUsecase,
        countryCodeUsecase: CountryCodeUsecase,
        registerPhoneUsecase: RegisterPhoneUsecase,
        saveNameUsecase: SaveNameUsecase,
        coordinator: any ContactInfoCoordinator,
        didTapLogin: @escaping () -> Void
    ) {
        self.fullnameValidationUsecase = fullnameValidationUsecase
        self.phoneValidationUsecase = phoneValidationUsecase
        self.countryCodeUsecase = countryCodeUsecase
        self.registerPhoneUsecase = registerPhoneUsecase
        self.saveNameUsecase = saveNameUsecase
        self.coordinator = coordinator
        self.didTapLogin = didTapLogin

        $fullname
            .dropFirst()
            .removeDuplicates()
            .map(fullnameValidationUsecase.execute)
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

    func didTapCountryCode() {
        if !countryCodes.isEmpty {
            launchCountryCode()
        } else {
            isLoading = true
            countryCodeUsecase.execute()
                .sink { [weak self] result in
                    guard let self = self else { return }
                    isLoading = false
                    switch result {
                    case let .success(result):
                        countryCodes = result
                        launchCountryCode()
                    case let .failure(error):
                        coordinator.present(.error(title: "Error", subtitle: error.localizedDescription, didDismiss: {}))
                    }
                }
                .store(in: &cancellables)
        }
    }

    func didTapCountinue() async {
        isLoading = true

        defer {
            isLoading = false
        }

        let result = await registerPhoneUsecase.execute(phone: countryCode.dialCode + phone)

        switch result {
        case let .success(verificationID):
            await coordinator.push(.otp(type: .phone(code: countryCode, phone: phone), verificationID: verificationID, didSuccess: { [weak self] in
                Task {
                    await self?.updateName()
                }
            }))
        case let .failure(error):
            coordinator.present(.error(title: "Error", subtitle: error.localizedDescription, didDismiss: {}))
        }
    }

    func launchLogin() {
        didTapLogin()
    }

    func launchCountryCode() {
        coordinator.present(.countryCode(selected: countryCode, items: countryCodes, didSelect: { [weak self] item in
            self?.countryCode = item
        }, didDismiss: {}))
    }

    func cancel() {
        for cancellable in cancellables {
            cancellable.cancel()
        }
        cancellables.removeAll()
    }

    private func updateName() async {
        isLoading = true

        defer {
            isLoading = false
        }

        let result = await saveNameUsecase.execute(name: fullname)

        switch result {
        case let .success(isEmailVerified):
            if isEmailVerified {
                await coordinator.push(.password)
            } else {
                await coordinator.push(.email)
            }
        case let .failure(error):
            coordinator.present(.error(title: "Error", subtitle: error.localizedDescription, didDismiss: {}))
        }
    }
}
