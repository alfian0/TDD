//
//  EmailRepository.swift
//  TextValidator
//
//  Created by Alfian on 14/10/24.
//

import Combine

protocol EmailRepository {
    func execute(email: String) -> AnyPublisher<Void, Error>
}
