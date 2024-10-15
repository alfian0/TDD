//
//  DefaultCountryCodeUsecase.swift
//  TextValidator
//
//  Created by Alfian on 02/10/24.
//

import Combine
import Foundation

enum CountryCodeError: Error {
    case ERROR_PARSE_JSON
    case UNKNOWN
}

protocol CountryCodeUsecase {
    func execute() -> AnyPublisher<[CountryCodeModel], CountryCodeError>
}

final class DefaultCountryCodeUsecase: CountryCodeUsecase {
    let service: CountryCodeRepository

    init(service: CountryCodeRepository) {
        self.service = service
    }

    func execute() -> AnyPublisher<[CountryCodeModel], CountryCodeError> {
        service.findAll()
            .map { items in
                items.map { item in
                    CountryCodeModel(
                        name: item.name,
                        flag: item.flag,
                        dialCode: item.dialCode,
                        code: item.code
                    )
                }
            }
            .catch { error in
                Fail(error: CountryCodeError.ERROR_PARSE_JSON)
            }
            .eraseToAnyPublisher()
    }
}
