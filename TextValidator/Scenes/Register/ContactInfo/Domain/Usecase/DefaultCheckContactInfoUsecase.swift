//
//  DefaultCheckContactInfoUsecase.swift
//  TextValidator
//
//  Created by Alfian on 07/10/24.
//

import Foundation
import Combine

enum ContactInfoError: Error, Equatable {
	case ALREADY_REGISTERED
	case NETWORK_ERROR(Error)
	case UNKNOWN
	
	static func == (lhs: ContactInfoError, rhs: ContactInfoError) -> Bool {
		switch (lhs, rhs) {
			case (.ALREADY_REGISTERED, .ALREADY_REGISTERED):
				return true
			case (.NETWORK_ERROR(let lhsError), .NETWORK_ERROR(let rhsError)):
				return (lhsError as NSError).domain == (rhsError as NSError).domain &&
				(lhsError as NSError).code == (rhsError as NSError).code
			case (.UNKNOWN, .UNKNOWN):
				return true
			default:
				return false
		}
	}
}

protocol CheckContactInfoUsecase {
	func execute(fullname: String, phone: String) -> AnyPublisher<AccountLevel, ContactInfoError>
}

final class DefaultCheckContactInfoUsecase: CheckContactInfoUsecase {
	private let service: CheckContactInfoRepository
	
	init(service: CheckContactInfoRepository) {
		self.service = service
	}
	
	func execute(fullname: String, phone: String) -> AnyPublisher<AccountLevel, ContactInfoError> {
		return service.execute(fullname: fullname, phone: phone)
			.compactMap({ AccountLevel(rawValue: $0.type) })
			.catch({ error -> AnyPublisher<AccountLevel, ContactInfoError> in
				if (error as NSError).code == 404 {
					return Fail(error: ContactInfoError.NETWORK_ERROR(error))
						.eraseToAnyPublisher()
				} else {
					return Fail(error: ContactInfoError.ALREADY_REGISTERED)
						.eraseToAnyPublisher()
				}
			})
			.eraseToAnyPublisher()
	}
}
