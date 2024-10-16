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
    let service: DefaultCountryCodeService

    init(service: DefaultCountryCodeService) {
        self.service = service
    }

    func execute() async -> Result<[CountryCodeModel], CountryCodeError> {
        do {
            let countries = try await service.findAll()
            let mappedCountries = countries.map { CountryCodeResponseMapper.map(country: $0) }
            return .success(mappedCountries)
        } catch {
            return .failure(.ERROR_PARSE_JSON)
        }
    }
}
