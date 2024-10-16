//
//  BiometricAuthRepository.swift
//  TextValidator
//
//  Created by Alfian on 16/10/24.
//

protocol BiometricAuthRepository {
    func saveBiometricPreference(enabled: Bool)
    func isBiometricEnabled() -> Bool
}

final class BiometricAuthRepositoryImpl: BiometricAuthRepository {
    private let keychainService: KeychainService

    init(keychainService: KeychainService) {
        self.keychainService = keychainService
    }

    func saveBiometricPreference(enabled: Bool) {
        keychainService.saveBiometricEnabled(enabled: enabled)
    }

    func isBiometricEnabled() -> Bool {
        return keychainService.isBiometricEnabled()
    }
}
