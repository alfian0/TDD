//
//  ContactInfoViewModel.swift
//  TextValidator
//
//  Created by Alfian on 02/10/24.
//

import Combine
import Foundation

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

    private let fullnameValidationUsecase: FullNameValidationUsecase
    private let phoneValidationUsecase: PhoneValidationUsecase
    private let countryCodeUsecase: CountryCodeUsecase
    private let checkContactInfoUsecase: CheckContactInfoUsecase
    private var coordinator: any ContactInfoCoordinator

    var cancellables = Set<AnyCancellable>()

    init(
        fullnameValidationUsecase: FullNameValidationUsecase,
        phoneValidationUsecase: PhoneValidationUsecase,
        countryCodeUsecase: CountryCodeUsecase,
        checkContactInfoUsecase: CheckContactInfoUsecase,
        coordinator: any ContactInfoCoordinator
    ) {
        self.fullnameValidationUsecase = fullnameValidationUsecase
        self.phoneValidationUsecase = phoneValidationUsecase
        self.countryCodeUsecase = countryCodeUsecase
        self.checkContactInfoUsecase = checkContactInfoUsecase
        self.coordinator = coordinator

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

    func didTapCountinue() {
        isLoading = true
        checkContactInfoUsecase.execute(fullname: fullname, phone: countryCode.dialCode + phone)
            .sink { [weak self] result in
                guard let self = self else { return }
                isLoading = false
                switch result {
                case let .success(verificationID):
                    coordinator.push(.otp(type: .phone(code: countryCode, phone: phone), verificationID: verificationID))
                case let .failure(error):
                    coordinator.present(.error(title: "Error", subtitle: error.localizedDescription, didDismiss: {}))
                }
            }
            .store(in: &cancellables)
    }

    func launchLogin() {
        coordinator.present(.login)
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
}
