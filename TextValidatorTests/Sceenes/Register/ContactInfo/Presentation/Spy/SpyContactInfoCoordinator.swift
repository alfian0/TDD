//
//  SpyContactInfoCoordinator.swift
//  TextValidator
//
//  Created by Alfian on 09/10/24.
//

@testable import TextValidator

final class SpyContactInfoCoordinator: ContactInfoCoordinator {
    var didPresentError = false
    var didPushOTP = false
    var didPushEmail = false
    var didPresentCountryCode = false
    var didPresentLogin = false

    func start() {}
    func push(_ page: ContactInfoCoordinatorPage) {
        switch page {
        case .otp:
            didPushOTP = true
        case .email:
            didPushEmail = true
        default:
            break
        }
    }

    func present(_ sheet: ContactInfoCoordinatorSheet) {
        switch sheet {
        case .error:
            didPresentError = true
        case .countryCode:
            didPresentCountryCode = true
        case .login:
            didPresentLogin = true
        default:
            break
        }
    }
}
