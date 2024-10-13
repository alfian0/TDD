//
//  MapperProtocol.swift
//  TextValidator
//
//  Created by Alfian on 03/10/24.
//

protocol MapperProtocol {
    associatedtype Domain
    associatedtype Data

    func toDomain(data: Data) -> Domain
    func toData(domain: Domain) -> Data
}

struct CountryCodeMapper: MapperProtocol {
    func toDomain(data: CountryCodeResponse) -> CountryCodeModel {
        CountryCodeModel(
            name: data.name,
            flag: data.flag,
            dialCode: data.dialCode,
            code: data.code
        )
    }

    func toData(domain: CountryCodeModel) -> CountryCodeResponse {
        CountryCodeResponse(
            name: domain.name,
            flag: domain.flag,
            dialCode: domain.dialCode,
            code: domain.code
        )
    }
}
