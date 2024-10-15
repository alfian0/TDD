//
//  UserMapper.swift
//  TextValidator
//
//  Created by Alfian on 15/10/24.
//

import FirebaseAuth

enum UserMapper {
    static func map(user: User) -> UserModel {
        return UserModel(
            providerID: user.providerID,
            uid: user.uid,
            displayName: user.displayName,
            photoURL: user.photoURL,
            email: user.email,
            phoneNumber: user.phoneNumber
        )
    }
}
