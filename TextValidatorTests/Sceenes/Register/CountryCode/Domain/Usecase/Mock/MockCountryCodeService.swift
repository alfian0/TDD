//
//  MockCountryCodeService.swift
//  TextValidator
//
//  Created by Alfian on 09/10/24.
//

import Combine
import Foundation
@testable import TextValidator

class MockCountryCodeService: CountryCodeRepository {
    var result: [TextValidator.CountryCodeResponse]?
    var error: NSError?

    func findAll() -> AnyPublisher<[TextValidator.CountryCodeResponse], any Error> {
        guard let result = result else {
            return Fail(error: error ?? NSError(domain: "", code: 404))
                .eraseToAnyPublisher()
        }

        return Just(result)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
