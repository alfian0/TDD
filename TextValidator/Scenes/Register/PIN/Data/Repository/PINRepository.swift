//
//  AuthRepository.swift
//  TextValidator
//
//  Created by Alfian on 10/10/24.
//

import Combine

protocol PINRepository {
	func verifyPIN(pin: String) -> AnyPublisher<Void, Error>
}
