//
//  PINViewModel.swift
//  TextValidator
//
//  Created by Alfian on 08/10/24.
//

import Combine
import Foundation

enum PINViewState {
    case enter
    case reenter
}

@MainActor
final class PINViewModel: ObservableObject {
    @Published var title: String = "Set PIN"
    @Published var subtitle: String = "Enter a 6-digit PIN for account security and authentication"
    @Published var passcode: String = ""
    @Published var passcodeError: String?

    private(set) var count: Int
    private(set) var coordinator: PINCoordinator
    private(set) var cancellables = Set<AnyCancellable>()

    private var currentPasscode: String = ""
    private let verifyPINUsecase: PINValidationUsecase
    private let didFinish: () -> Void

    init(
        count: Int,
        verifyPINUsecase: PINValidationUsecase,
        coordinator: PINCoordinator,
        didFinish: @escaping () -> Void
    ) {
        self.count = count
        self.verifyPINUsecase = verifyPINUsecase
        self.coordinator = coordinator
        self.didFinish = didFinish

        $passcode
            .filter { $0.count == count }
            .sink { [weak self] _ in
                guard let self = self else { return }
                verifyPIN()
            }
            .store(in: &cancellables)
    }

    func back() {
        if !currentPasscode.isEmpty, currentPasscode.count == count {
            view(with: .enter)
        } else {
            didFinish()
        }
    }

    private func view(with state: PINViewState) {
        switch state {
        case .enter:
            title = "Set PIN"
            currentPasscode = ""
        case .reenter:
            currentPasscode = passcode
            title = "Re enter your PIN"
        }
        passcode = ""
        passcodeError = nil
    }

    private func verifyPIN() {
        verifyPINUsecase.execute(pin: passcode, repin: currentPasscode)
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(isVerify):
                    if isVerify {
                        coordinator.push(.pin)
                    } else {
                        self.view(with: .reenter)
                    }
                case let .failure(error):
                    switch error {
                    case let .TEXT_ERROR(error):
                        self.passcodeError = error.localizedDescription
                    case .NETWORK_ERROR: break
                    }
                }
            }
            .store(in: &cancellables)
    }
}
