//
//  BiometricRepositoryImpl.swift
//  TextValidator
//
//  Created by Alfian on 17/10/24.
//

final class BiometricRepositoryImpl: BiometricRepository {
    private let service: BiometricService

    init(service: BiometricService) {
        self.service = service
    }

    func isBiometricAvailable() async throws -> Bool {
        try service.isBiometricAvailable()
    }

    func biometricType() -> BiometricType {
        switch service.biometricType() {
        case .none:
            return .none
        case .faceID:
            return .face
        case .touchID:
            return .touch
        case .opticID:
            return .optic
        @unknown default:
            return .none
        }
    }

    func authenticateWithBiometrics() async throws -> Bool {
        try await service.authenticateWithBiometrics()
    }
}
