//
//  CheckContactInfoRepository.swift
//  TextValidator
//
//  Created by Alfian on 10/10/24.
//

import Combine

protocol CheckContactInfoRepository {
    func execute(fullname: String, phone: String) -> AnyPublisher<String, Error>
}
