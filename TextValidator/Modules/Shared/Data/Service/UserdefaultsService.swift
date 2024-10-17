//
//  UserdefaultsService.swift
//  TextValidator
//
//  Created by Alfian on 17/10/24.
//

import Foundation

enum UserdefaultsConstants {
    static let email = "email"
}

final class UserdefaultsService {
    private let userdefaults = UserDefaults.standard

    func saveEmail(_ email: String) {
        UserDefaults.standard.set(email, forKey: UserdefaultsConstants.email)
    }

    func getEmail() -> String? {
        return UserDefaults.standard.string(forKey: UserdefaultsConstants.email)
    }

    func removeEmail() {
        UserDefaults.standard.removeObject(forKey: UserdefaultsConstants.email)
    }
}
