//
//  TextValidatorApp.swift
//  TextValidator
//
//  Created by Alfian on 30/09/24.
//

import FirebaseCore
import SwiftUI

class AppDelegate: UIResponder, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.all

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }

    func application(_: UIApplication, didReceiveRemoteNotification _: [AnyHashable: Any], fetchCompletionHandler _: @escaping (UIBackgroundFetchResult) -> Void) {}

    func application(_: UIApplication, supportedInterfaceOrientationsFor _: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}

@main
struct TextValidatorApp: App {
    @Environment(\.openURL) var openURL
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let coordinator = MainAppCoordinatorImpl()

    var body: some Scene {
        WindowGroup {
//            CameraView(viewModel: CameraViewModel())
            NavigationControllerWrapper(coordinator: coordinator)
                .edgesIgnoringSafeArea(.all)
                .onViewDidLoad {
                    Task {
                        for await user in FirebaseAuthService().authStateChangeStream() {
                            if let user = user {
                                coordinator.push(.home)
                            } else {
                                coordinator.start()
                            }
                        }
                    }
                }
                .onOpenURL { url in

                    // MARK: FirebaseAuth

                    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                        return
                    }
                    guard let queryItems = components.queryItems else {
                        return
                    }
                    guard let urlString = queryItems.filter({ $0.name == "ifl" }).first?.value else {
                        return
                    }
                    guard let url = URL(string: urlString) else {
                        return
                    }
                    Task {
                        do {
                            let items = try await url.handleDeeplinkType(type: verificationEmailDeeplink)
                            coordinator.present(.password)
                        } catch {
                            print(error)
                        }
                    }
                }
        }
    }
}
