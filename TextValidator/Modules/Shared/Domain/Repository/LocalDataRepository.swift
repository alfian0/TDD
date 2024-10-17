//
//  LocalDataRepository.swift
//  TextValidator
//
//  Created by Alfian on 17/10/24.
//

protocol LocalDataRepository {
    func getCountryCodes() async throws -> [CountryCodeModel]
}
