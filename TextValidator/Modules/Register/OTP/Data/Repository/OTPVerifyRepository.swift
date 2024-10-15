//
//  OTPVerifyRepository.swift
//  TextValidator
//
//  Created by Alfian on 13/10/24.
//

import Combine
import FirebaseAuth

protocol OTPVerifyRepository {
    func execute(verificationID: String, verificationCode: String) -> AnyPublisher<AuthDataResult, Error>
}
