//
//  ContactViewAssembler.swift
//  TextValidator
//
//  Created by Alfian on 22/10/24.
//

import Swinject
import UIKit

@MainActor
final class ContactViewAssembler: @preconcurrency Assembly {
    func assemble(container: Swinject.Container) {
        container.register(ContactInfoCoordinatorDeeplink.self) { (r, n: UINavigationController) in
            guard let wrapped = r.resolve(ContactInfoCoordinatorImpl.self, argument: n) else {
                fatalError()
            }
            return ContactInfoCoordinatorDeeplink(wrapped: wrapped)
        }

        container.register(ContactInfoCoordinatorImpl.self) { _, n in
            ContactInfoCoordinatorImpl(navigationController: n)
        }

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

        container.register(ContactInfoView.self) { (r, c: ContactInfoCoordinatorImpl, d: @escaping (() -> Void)) in
            guard let viewModel = r.resolve(ContactInfoViewModel.self, arguments: c, d) else {
                fatalError()
            }
            return ContactInfoView(viewModel: viewModel)
        }
    }
}
