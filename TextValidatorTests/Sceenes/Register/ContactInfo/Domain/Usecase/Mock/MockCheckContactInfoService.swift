//
//  MockCheckContactInfoService.swift
//  TextValidator
//
//  Created by Alfian on 09/10/24.
//

import Combine
import Foundation
@testable import TextValidator

final class MockCheckContactInfoService: CheckContactInfoRepository {
    var result: TextValidator.ContactInfoResponse?
    var error: NSError?

    func execute(fullname _: String, phone _: String) -> AnyPublisher<TextValidator.ContactInfoResponse, any Error> {
        guard let result = result else {
            return Fail(error: error ?? NSError(domain: "", code: 404))
                .eraseToAnyPublisher()
        }
        return Just(result)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
