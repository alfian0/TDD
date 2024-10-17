//
//  LocalDataRepositoryImpl.swift
//  TextValidator
//
//  Created by Alfian on 17/10/24.
//

final class LocalDataRepositoryImpl: LocalDataRepository {
    private let service: LocalDataService

    init(service: LocalDataService) {
        self.service = service
    }

    func getCountryCodes() async throws -> [CountryCodeModel] {
        return try await service.getCountryCodes().map { CountryCodeResponseMapper.map(country: $0) }
    }
}
