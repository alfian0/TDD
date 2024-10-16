//
//  KeychainService.swift
//  TextValidator
//
//  Created by Alfian on 16/10/24.
//

import Security

final class KeychainService {
    private let biometricKey = "com.app.biometricEnabled"

    func saveBiometricEnabled(enabled: Bool) {
        let status = KeychainHelper.save(data: enabled ? "1" : "0", forKey: biometricKey)
        if status != errSecSuccess {
            print("Failed to save biometric preference")
        }
    }

    func isBiometricEnabled() -> Bool {
        guard let biometricStatus = KeychainHelper.retrieveData(forKey: biometricKey) else {
            return false
        }
        return biometricStatus == "1"
    }
}
