//
//  VerifyOTPRepository.swift
//  TextValidator
//
//  Created by Alfian on 15/10/24.
//

final class VerifyOTPRepository {
    private let service: FirebaseRegisterService

    init(service: FirebaseRegisterService) {
        self.service = service
    }

    func verifyCode(verificationID: String, verificationCode: String) async throws -> UserModel {
        let result = try await service.verifyCode(verificationID: verificationID, verificationCode: verificationCode)
        return UserMapper.map(user: result.user)
    }
}
