//
//  OTPType.swift
//  TextValidator
//
//  Created by Alfian on 07/10/24.
//

enum OTPType: Equatable {
    case phone(code: CountryCodeModel, phone: String)
    case email(email: String)

    var title: String {
        switch self {
        case .phone:
            return "Verify your phone number"
        case .email:
            return "Verify your email"
        }
    }

    var subtitle: String {
        let subtitle = "Enter the 5-digit OTP code sent to "
        switch self {
        case let .phone(code, phone):
            return subtitle + "(\(code.dialCode))" + phone
        case let .email(email):
            return subtitle + email
        }
    }
}
