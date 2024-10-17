//
//  BiometricRepository.swift
//  TextValidator
//
//  Created by Alfian on 17/10/24.
//

protocol BiometricRepository {
    func isBiometricAvailable() async throws -> Bool
    func biometricType() -> BiometricType
    func authenticateWithBiometrics() async throws -> Bool
}
