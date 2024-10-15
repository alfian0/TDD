//
//  PasswordRepository.swift
//  TextValidator
//
//  Created by Alfian on 14/10/24.
//

import Combine
import FirebaseAuth

protocol PasswordRepository {
    func update(password: String) -> AnyPublisher<User?, Error>
}
