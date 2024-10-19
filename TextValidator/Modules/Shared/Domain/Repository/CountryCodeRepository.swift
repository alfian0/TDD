//
//  CountryCodeRepository.swift
//  TextValidator
//
//  Created by Alfian on 17/10/24.
//

protocol CountryCodeRepository {
    func getCountryCodes() async throws -> [CountryCodeModel]
}
