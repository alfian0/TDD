//
//  PINService.swift
//  TextValidator
//
//  Created by Alfian on 10/10/24.
//

import Foundation
import Combine

final class SetPINService: PINRepository {
	func verifyPIN(pin: String) -> AnyPublisher<Void, any Error> {
		if pin == "261092" {
			return Fail(error: NSError(domain: "", code: 404))
				.eraseToAnyPublisher()
		} else {
			return Just(())
				.setFailureType(to: Error.self)
				.eraseToAnyPublisher()
		}
	}
}
