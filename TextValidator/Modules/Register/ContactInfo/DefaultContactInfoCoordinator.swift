//
//  DefaultContactInfoCoordinator.swift
//  TextValidator
//
//  Created by Alfian on 09/10/24.
//

import SwiftUI

enum ContactInfoCoordinatorPage {
    case otp(type: OTPType, verificationID: String, didSuccess: () -> Void)
    case email
    case password
}

enum ContactInfoCoordinatorSheet {
    case error(title: String, subtitle: String, didDismiss: () -> Void)
    case countryCode(
        selected: CountryCodeModel,
        items: [CountryCodeModel],
        didSelect: (CountryCodeModel) -> Void,
        didDismiss: () -> Void
    )
}

protocol ContactInfoCoordinator: Coordinator {
    func start(didTapLogin: @escaping () -> Void)
    func push(_ page: ContactInfoCoordinatorPage)
    func present(_ sheet: ContactInfoCoordinatorSheet)
}

final class DefaultContactInfoCoordinator: ContactInfoCoordinator {
    var childCoordinator: [any Coordinator] = .init()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    func start(didTapLogin: @escaping () -> Void) {
        let vm = ContactInfoViewModel(
            fullnameValidationUsecase: NameValidationUsecase(),
            phoneValidationUsecase: PhoneValidationUsecase(),
            countryCodeUsecase: DefaultCountryCodeUsecase(service: DefaultCountryCodeService()),
            verifyPhoneUsecase: VerifyPhoneUsecase(service: DefaultCheckContactInfoService()),
            updateNameUsecase: UpdateNameUsecase(service: DefaultCheckContactInfoService()),
            coordinator: self,
            didTapLogin: didTapLogin
        )
        let v = ContactInfoView(viewModel: vm)
        let vc = UIHostingController(rootView: v)

        navigationController.show(vc, sender: navigationController)
    }

    func start(_ deeplink: DeeplinkType, didTapLogin: @escaping () -> Void) {
        start(didTapLogin: didTapLogin)
        let coordinator = EmailCoordinator(navigationController: navigationController)
        coordinator.start(deeplink)
    }

    func push(_ page: ContactInfoCoordinatorPage) {
        switch page {
        case let .otp(type, verificationID, didSuccess):
            let coordinator = OTPCoordinator(navigationController: navigationController)
            coordinator.start(
                type: type,
                verificationID: verificationID,
                didSuccess: {
                    didSuccess()
                }
            )

        case .email:
            let coordinator = EmailCoordinator(navigationController: navigationController)
            coordinator.start(viewState: .formInput)

        case .password:
            let coordinator = PasswordCoordinator(navigationController: navigationController)
            coordinator.start()
        }
    }

    func present(_ sheet: ContactInfoCoordinatorSheet) {
        switch sheet {
        case let .error(title, subtitle, didDismiss):
            let coordinator = ErrorCoordinator()
            coordinator.start(title: title, subtitle: subtitle, didDismiss: { [weak self] in
                didDismiss()
                self?.navigationController.dismiss(animated: true)
                self?.childCoordinator.removeLast()
            })
            coordinator.navigationController.modalPresentationStyle = .fullScreen
            childCoordinator.append(coordinator)
            navigationController.showDetailViewController(coordinator.navigationController, sender: navigationController)

        case let .countryCode(selected, items, didSelect, didDismiss):
            let coordinator = CountryCodeCoordinator()
            coordinator.start(
                selected: selected,
                items: items,
                didSelect: { [weak self] item in
                    didSelect(item)
                    self?.navigationController.dismiss(animated: true, completion: {
                        self?.childCoordinator.removeLast()
                    })
                },
                didDismiss: { [weak self] in
                    didDismiss()
                    self?.navigationController.dismiss(animated: true, completion: {
                        self?.childCoordinator.removeLast()
                    })
                }
            )
            coordinator.navigationController.modalPresentationStyle = .fullScreen
            childCoordinator.append(coordinator)
            navigationController.showDetailViewController(coordinator.navigationController, sender: navigationController)
        }
    }
}