//
//  MockCountryCodeRepository.swift
//  TextValidator
//
//  Created by Alfian on 09/10/24.
//

import Combine
@testable import TextValidator

// final class MockCountryCodeRepository: CountryCodeUsecase {
//    var result: [TextValidator.CountryCodeModel]?
//    var error: TextValidator.CountryCodeError?
//
//    func execute() -> AnyPublisher<[TextValidator.CountryCodeModel], TextValidator.CountryCodeError> {
//        guard let result = result else {
//            return Fail(error: error ?? TextValidator.CountryCodeError.UNKNOWN)
//                .eraseToAnyPublisher()
//        }
//        return Just(result)
//            .setFailureType(to: TextValidator.CountryCodeError.self)
//            .eraseToAnyPublisher()
//    }
// }
