//
//  TextValidatorApp.swift
//  TextValidator
//
//  Created by Alfian on 30/09/24.
//

import FirebaseCore
import SwiftUI
import Swinject

@MainActor
final class AppAssembler {
    static let shared: Assembler = .init([
        VisionRepositoryImplAssembly(),
        CountryCodeRepositoryImplAssembly(),
        AuthRepositoryImplAssembly(),
        VisionServiceAssembly(),
        UserdefaultsServiceAssembly(),
        BiometricServiceAssembly(),
        KeychainServiceAssembly(),
        FirebaseAuthServiceAssembly(),
        CameraServiceAssembly(),
        ExtractKTPUsecaseAssembly(),
        ExtractNIKUsecaseAssembly(),
        ExtractDOBUsecaseAssembly(),
        ExtractNationalityTypeUsecaseAssembly(),
        ExtractJobTypeUsecaseAssembly(),
        ExtractReligionTypeUsecaseAssembly(),
        ExtractMaritalStatusUsecaseAssembly(),
        ExtractGenderUsecaseAssembly(),
        AgeValidationUsecaseAssembly(),
        NIKValidationUsecaseAssembly(),
        NameValidationUsecaseAssembly(),
        PINValidationUsecaseAssembly(),
        EmailValidationUsecaseAssembly(),
        PhoneValidationUsecaseAssembly(),
        LoginViewCoordinatorAssembly(),
        LoginBiometricUsecaseAssembly(),
        LoginUsecaseAssembly(),
        LoginViewModelAssembly(),
        LoginViewAssembly(),
        OCRViewCoordinatorAssembly(),
        OCRViewModelAssembly(),
        OCRViewAssembly(),
        ContactInfoCoordinatorDeeplinkAssembly(),
        ContactInfoCoordinatorAssembly(),
        SaveNameUsecaseAssembly(),
        RegisterPhoneUsecaseAssembly(),
        VerifyOTPUsecaseAssembly(),
        ContactInfoViewModelAssembly(),
        ContactInfoViewAssembly(),
        CountryCodeUsecaseAssembly(),
    ])
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        FirebaseApp.configure()
        return true
    }

    func application(_: UIApplication, didReceiveRemoteNotification _: [AnyHashable: Any], fetchCompletionHandler _: @escaping (UIBackgroundFetchResult) -> Void) {}
}

@main
struct TextValidatorApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let coordinator = MainAppCoordinatorDeeplink(wrapped: MainAppCoordinatorImpl())

    var body: some Scene {
        WindowGroup {
            NavigationControllerWrapper(coordinator: coordinator)
                .edgesIgnoringSafeArea(.all)
                .onViewDidLoad {
                    coordinator.start()
                }
                .onOpenURL { url in
                    guard let path = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                        return
                    }
                    guard let queryItems = path.queryItems else {
                        return
                    }
                    guard let link = queryItems.filter({ $0.name == "link" }).first?.value else {
                        return
                    }
                    if let host = path.host, host == "textvalidator.page.link" {
                        coordinator.start(.verifyEmail(link: link))
                    }
                }
        }
    }
}
