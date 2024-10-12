//
//  PINViewModel.swift
//  TextValidator
//
//  Created by Alfian on 08/10/24.
//

import Foundation
import Combine

enum PINViewState {
	case enter
	case reenter
}

final class PINViewModel: ObservableObject {
	@Published var title: String = "Set PIN"
	@Published var subtitle: String = "Enter a 6-digit PIN for account security and authentication"
	@Published var passcode: String = ""
	@Published var passcodeError: String?
	
	private(set) var count: Int
	private(set) var coordinator: PINCoordinator
	private(set) var cancellables = Set<AnyCancellable>()
	
	private var currentPasscode: String = ""
	private let verifyPINUsecase: VerifyPINUsecase
	
	init(
		count: Int,
		verifyPINUsecase: VerifyPINUsecase,
		coordinator: PINCoordinator
	) {
		self.count = count
		self.verifyPINUsecase = verifyPINUsecase
		self.coordinator = coordinator
		
		$passcode
			.filter({ $0.count == count })
			.receive(on: RunLoop.main)
			.sink { [weak self] value in
				guard let self = self else { return }
				verifyPINUsecase.execute(pin: passcode, repin: currentPasscode)
					.sink { result in
						switch result {
							case .success(let isVerify):
								if isVerify {
									coordinator.goToPassword()
								} else {
									self.view(with: .reenter)
								}
							case .failure(let error):
								switch error {
									case .TEXT_ERROR(let error):
										self.passcodeError = error.localizedDescription
									case .NETWORK_ERROR(let error): break
								}
						}
					}
					.store(in: &cancellables)
			}
			.store(in: &cancellables)
	}
	
	func back() {
		if !currentPasscode.isEmpty, currentPasscode.count == count {
			view(with: .enter)
		} else {
			coordinator.finish()
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
}
