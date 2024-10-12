//
//  MockCheckContactInfoService.swift
//  TextValidator
//
//  Created by Alfian on 09/10/24.
//

import Foundation
import Combine
@testable import TextValidator

final class MockCheckContactInfoService: CheckContactInfoRepository {
	var result: TextValidator.ContactInfoResponse?
	var error: NSError?
	
	func execute(fullname: String, phone: String) -> AnyPublisher<TextValidator.ContactInfoResponse, any Error> {
		guard let result = result else {
			return Fail(error: error ?? NSError(domain: "", code: 404))
				.eraseToAnyPublisher()
		}
		return Just(result)
			.setFailureType(to: Error.self)
			.eraseToAnyPublisher()
	}
}
