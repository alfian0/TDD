//
//  EmailRepository.swift
//  TextValidator
//
//  Created by Alfian on 14/10/24.
//

import Combine
import FirebaseAuth

protocol EmailRepository {
    func sendEmailVerification(email: String) -> AnyPublisher<Void, Error>
}
