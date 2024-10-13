//
//  MockCheckContactInfoRepository.swift
//  TextValidator
//
//  Created by Alfian on 09/10/24.
//

import Combine
@testable import TextValidator

final class MockCheckContactInfoRepository: CheckContactInfoUsecase {
    var result: TextValidator.AccountLevel?
    var error: TextValidator.ContactInfoError?

    func execute(fullname _: String, phone _: String) -> AnyPublisher<TextValidator.AccountLevel, TextValidator.ContactInfoError> {
        guard let result = result else {
            return Fail(error: error ?? TextValidator.ContactInfoError.UNKNOWN)
                .eraseToAnyPublisher()
        }
        return Just(result)
            .setFailureType(to: TextValidator.ContactInfoError.self)
            .eraseToAnyPublisher()
    }
}
