//
//  CountryCodeRepository.swift
//  TextValidator
//
//  Created by Alfian on 10/10/24.
//

import Combine

protocol CountryCodeRepository {
	func findAll() -> AnyPublisher<[CountryCodeResponse], Error>
}
