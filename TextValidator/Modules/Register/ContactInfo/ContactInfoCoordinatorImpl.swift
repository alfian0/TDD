//
//  ContactInfoCoordinatorImpl.swift
//  TextValidator
//
//  Created by Alfian on 09/10/24.
//

import SwiftUI

enum ContactInfoCoordinatorPage {
    case email
    case password
}

enum ContactInfoCoordinatorSheet {
    case error(title: String, subtitle: String, onDismiss: () -> Void)
    case countryCode(
        selected: CountryCodeModel,
        items: [CountryCodeModel],
        onSelect: (CountryCodeModel) -> Void,
        onDismiss: () -> Void
    )
    case otp(
        title: String,
        subtitle: String,
        count: Int,
        duration: Int,
        onResendTapped: () -> Void,
        onOTPChanged: () -> Void,
        onOTPSuccess: (String) -> Void
    )
}

protocol ContactInfoCoordinator: Coordinator {
    func start(onLoginTapped: @escaping () -> Void) async
    func push(_ page: ContactInfoCoordinatorPage) async
    func present(_ sheet: ContactInfoCoordinatorSheet) async
}

final class ContactInfoCoordinatorImpl: ContactInfoCoordinator {
    var childCoordinator: [any Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    @MainActor
    func start(onLoginTapped: @escaping () -> Void) {
        guard let view = AppAssembler.shared.resolver.resolve(ContactInfoView.self, arguments: self, onLoginTapped) else {
            return
        }
        let vc = UIHostingController(rootView: view)
        navigationController.show(vc, sender: nil)
    }

    @MainActor
    func push(_ page: ContactInfoCoordinatorPage) {
        switch page {
        case .email:
            guard let coordinator = AppAssembler.shared.resolver.resolve(EmailCoordinatorImpl.self, argument: navigationController) else {
                return
            }
            coordinator.start()

        case .password:
            guard let coordinator = AppAssembler.shared.resolver.resolve(PasswordCoordinator.self, argument: navigationController) else {
                return
            }
            coordinator.start()
        }
    }

    @MainActor
    func present(_ sheet: ContactInfoCoordinatorSheet) {
        switch sheet {
        case let .error(title, subtitle, onDismiss):
            guard let coordinator = AppAssembler.shared.resolver.resolve(ErrorCoordinator.self, argument: UINavigationController()) else {
                return
            }
            coordinator.start(title: title, subtitle: subtitle, didDismiss: { [weak self] in
                self?.dismissCoordinator(coordinator, completion: onDismiss)
            })
            presentModal(coordinator)

        case let .otp(title, subtitle, count, duration, onResendTapped, onOTPChanged, onOTPSuccess):
            guard let coordinator = AppAssembler.shared.resolver.resolve(OTPCoordinator.self, argument: UINavigationController()) else {
                return
            }
            coordinator.start(
                title: title,
                subtitle: subtitle,
                count: count,
                duration: duration,
                didResend: onResendTapped,
                didChange: { [weak self] in
                    self?.dismissCoordinator(coordinator, completion: {
                        onOTPChanged()
                    })
                },
                didSuccess: { [weak self] otp in
                    self?.dismissCoordinator(coordinator, completion: {
                        onOTPSuccess(otp)
                    })
                }
            )
            presentModal(coordinator)

        case let .countryCode(selected, items, onSelect, onDismiss):
            guard let coordinator = AppAssembler.shared.resolver.resolve(CountryCodeCoordinator.self, argument: UINavigationController()) else {
                return
            }
            coordinator.start(
                selected: selected,
                items: items,
                didSelect: { [weak self] item in
                    self?.dismissCoordinator(coordinator, completion: { onSelect(item) })
                },
                didDismiss: { [weak self] in
                    self?.dismissCoordinator(coordinator, completion: onDismiss)
                }
            )
            presentModal(coordinator)
        }
    }

    // MARK: - Helpers

    private func presentModal(_ coordinator: any Coordinator) {
        coordinator.navigationController.modalPresentationStyle = .fullScreen
        childCoordinator.append(coordinator)
        navigationController.showDetailViewController(coordinator.navigationController, sender: nil)
    }

    private func dismissCoordinator(_ coordinator: any Coordinator, completion: @escaping () -> Void) {
        navigationController.dismiss(animated: true, completion: {
            self.removeCoordinator(coordinator)
            completion()
        })
    }

    private func removeCoordinator(_ coordinator: any Coordinator) {
        if let index = childCoordinator.firstIndex(where: { $0 === coordinator }) {
            childCoordinator.remove(at: index)
        }
    }
}
