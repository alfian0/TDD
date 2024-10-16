//
//  KeychainHelper.swift
//  TextValidator
//
//  Created by Alfian on 16/10/24.
//

import Foundation
import Security

enum KeychainHelper {
    @discardableResult
    static func save(data: String, forKey key: String) -> OSStatus {
        guard let data = data.data(using: .utf8) else {
            return errSecParam
        }

        // Create a query to check if the item already exists
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
        ]

        // Check if the item already exists
        SecItemDelete(query as CFDictionary)

        // Create a query to add the data to Keychain
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
        ]

        return SecItemAdd(attributes as CFDictionary, nil)
    }

    static func retrieveData(forKey key: String) -> String? {
        // Create a query to retrieve the data from Keychain
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]

        var dataRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataRef)

        if status == errSecSuccess, let data = dataRef as? Data {
            return String(data: data, encoding: .utf8)
        }

        return nil
    }

    @discardableResult
    static func delete(forKey key: String) -> OSStatus {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
        ]

        return SecItemDelete(query as CFDictionary)
    }
}
