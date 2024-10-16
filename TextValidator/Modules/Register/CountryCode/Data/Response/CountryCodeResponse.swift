//
//  CountryCodeResponse.swift
//  TextValidator
//
//  Created by Alfian on 02/10/24.
//

struct CountryCodeResponse: Codable {
    let name: String
    let flag: String
    let dialCode: String
    let code: String
}

enum CountryCodeResponseMapper {
    static func map(country: CountryCodeResponse) -> CountryCodeModel {
        return CountryCodeModel(
            name: country.name,
            flag: country.flag,
            dialCode: country.dialCode,
            code: country.code
        )
    }
}
