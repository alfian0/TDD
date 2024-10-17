//
//  CountryCodeResponseMapper.swift
//  TextValidator
//
//  Created by Alfian on 16/10/24.
//

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
