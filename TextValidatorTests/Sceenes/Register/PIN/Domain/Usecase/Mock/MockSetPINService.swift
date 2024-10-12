//
//  MockSetPINService.swift
//  TextValidator
//
//  Created by Alfian on 12/10/24.
//

import Foundation
import Combine
@testable import TextValidator

final class MockSetPINService: PINRepository {
	var error: NSError?
	
	func verifyPIN(pin: String) -> AnyPublisher<Void, any Error> {
		guard let error = error else {
			return Just(())
				.setFailureType(to: Error.self)
				.eraseToAnyPublisher()
		}
		return Fail(error: error)
			.eraseToAnyPublisher()
	}
}
