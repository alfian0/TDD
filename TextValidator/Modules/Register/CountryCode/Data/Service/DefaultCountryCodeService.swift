//
//  DefaultCountryCodeService.swift
//  TextValidator
//
//  Created by Alfian on 02/10/24.
//

import Foundation

final class DefaultCountryCodeService {
    func findAll() async throws -> [CountryCodeResponse] {
        try Data.fromJSONFile("Dial").toCodable(with: [CountryCodeResponse].self)
    }
}
