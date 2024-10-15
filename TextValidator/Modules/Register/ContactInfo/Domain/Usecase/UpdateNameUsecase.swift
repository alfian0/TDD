//
//  UpdateNameUsecase.swift
//  TextValidator
//
//  Created by Alfian on 15/10/24.
//

import Combine

final class UpdateNameUsecase {
    private let service: CheckContactInfoRepository

    init(service: CheckContactInfoRepository) {
        self.service = service
    }

    func exec(fullname: String) -> AnyPublisher<UserModel, ContactInfoError> {
        service.update(fullname: fullname)
            .compactMap { $0 }
            .map { UserMapper.map(user: $0) }
            .catch { error -> AnyPublisher<UserModel, ContactInfoError> in
                Fail(error: ContactInfoError.UNKNOWN)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
