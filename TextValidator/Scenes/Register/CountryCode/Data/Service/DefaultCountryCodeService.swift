//
//  DefaultCountryCodeService.swift
//  TextValidator
//
//  Created by Alfian on 02/10/24.
//

import Combine
import Foundation

final class DefaultCountryCodeService: CountryCodeRepository {
    func findAll() -> AnyPublisher<[CountryCodeResponse], Error> {
        do {
            let countries = try Data.fromJSONFile("Dial").toCodable(with: [CountryCodeResponse].self)
            return Just(countries)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}
