//
//  CountryCodeRepositoryImpl.swift
//  TextValidator
//
//  Created by Alfian on 17/10/24.
//

import Foundation
import Swinject

class CountryCodeRepositoryImplAssembly: Assembly {
    func assemble(container: Container) {
        container.register(CountryCodeRepositoryImpl.self) { _ in
            CountryCodeRepositoryImpl()
        }
    }
}

final class CountryCodeRepositoryImpl: CountryCodeRepository {
    func getCountryCodes() async throws -> [CountryCodeModel] {
        return try Data.fromJSONFile("Dial")
            .toCodable(with: [CountryCodeResponse].self)
            .map { CountryCodeResponseMapper.map(country: $0) }
    }
}
