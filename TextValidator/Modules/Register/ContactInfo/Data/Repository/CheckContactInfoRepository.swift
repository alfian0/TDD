//
//  CheckContactInfoRepository.swift
//  TextValidator
//
//  Created by Alfian on 10/10/24.
//

import Combine
import FirebaseAuth

protocol CheckContactInfoRepository {
    func verify(phone: String) -> AnyPublisher<String, Error>
    func update(fullname: String) -> AnyPublisher<User?, Error>
}
