//
//  CountryCodeUsecase.swift
//  TextValidator
//
//  Created by Alfian on 02/10/24.
//

import Foundation

enum CountryCodeError: Error {
    case ERROR_PARSE_JSON
    case UNKNOWN
}

final class CountryCodeUsecase {
    let repository: CountryCodeRepository

    init(repository: CountryCodeRepository) {
        self.repository = repository
    }

    func execute() async -> Result<[CountryCodeModel], CountryCodeError> {
        do {
            let countries = try await repository.getCountryCodes()
            return .success(countries)
        } catch {
            return .failure(.ERROR_PARSE_JSON)
        }
    }
}
