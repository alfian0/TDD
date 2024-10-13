//
//  TextValidatorApp.swift
//  TextValidator
//
//  Created by Alfian on 30/09/24.
//

import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
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
    let coordinator = DefaultContactInfoCoordinator()

    var body: some Scene {
        WindowGroup {
            NavigationControllerWrapper(coordinator: coordinator)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    coordinator.start()
                }
        }
    }
}
