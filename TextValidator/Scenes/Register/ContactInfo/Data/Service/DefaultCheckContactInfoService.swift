//
//  DefaultCheckContactInfoService.swift
//  TextValidator
//
//  Created by Alfian on 07/10/24.
//

import Foundation
import Combine

final class DefaultCheckContactInfoService: CheckContactInfoRepository {
	func execute(fullname: String, phone: String) -> AnyPublisher<ContactInfoResponse, any Error> {
		if fullname == "error" {
			return Fail(error: NSError(domain: "", code: 404))
				.eraseToAnyPublisher()
		} else if phone.count == 7 {
			return Just(ContactInfoResponse(type: "two"))
				.setFailureType(to: Error.self)
				.eraseToAnyPublisher()
		} else {
			return Just(ContactInfoResponse(type: "one"))
				.setFailureType(to: Error.self)
				.eraseToAnyPublisher()
		}
	}
}
