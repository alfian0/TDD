//
//  KeychainService.swift
//  TextValidator
//
//  Created by Alfian on 16/10/24.
//

import KeychainSwift
import Swinject

class KeychainServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(KeychainService.self) { _ in
            KeychainService()
        }
    }
}

enum KeychainConstants {
    static let authToken = "authToken"
}

final class KeychainService {
    private let keychain = KeychainSwift()

    func saveToken(_ token: String) {
        keychain.set(token, forKey: KeychainConstants.authToken)
    }

    func getToken() -> String? {
        return keychain.get(KeychainConstants.authToken)
    }

    func deleteToken() {
        keychain.delete(KeychainConstants.authToken)
    }
}
