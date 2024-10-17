//
//  LocalDataService.swift
//  TextValidator
//
//  Created by Alfian on 17/10/24.
//

import Foundation

final class LocalDataService {
    func getCountryCodes() async throws -> [CountryCodeResponse] {
        try Data.fromJSONFile("Dial").toCodable(with: [CountryCodeResponse].self)
    }
}
