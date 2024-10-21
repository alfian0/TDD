//
//  BiometricService.swift
//  TextValidator
//
//  Created by Alfian on 16/10/24.
//

import LocalAuthentication
import Swinject

class BiometricServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(BiometricService.self) { _ in
            BiometricService()
        }
    }
}

class BiometricService {
    func isBiometricAvailable() throws -> Bool {
        let context = LAContext()
        var error: NSError?

        // Check if the device can evaluate the biometric policy
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return true // Biometric authentication is available
        } else {
            // Handle the error case
            throw error ?? NSError(domain: "BiometricAuthError", code: -1, userInfo: nil)
        }
    }

    func biometricType() -> LABiometryType {
        let context = LAContext()
        return context.biometryType
    }

    func authenticateWithBiometrics() async throws -> Bool {
        let context = LAContext()
        return try await withCheckedThrowingContinuation { continuation in
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate to login") { success, error in
                if success {
                    continuation.resume(returning: true)
                } else {
                    continuation.resume(throwing: error ?? NSError(domain: "BiometricAuthError", code: -1, userInfo: nil))
                }
            }
        }
    }
}
