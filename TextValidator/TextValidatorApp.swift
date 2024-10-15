//
//  TextValidatorApp.swift
//  TextValidator
//
//  Created by Alfian on 30/09/24.
//

import FirebaseCore
import SwiftUI

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
    let coordinator = MainAppCoordinator()

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
