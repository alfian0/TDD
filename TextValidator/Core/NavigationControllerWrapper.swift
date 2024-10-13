//
//  NavigationControllerWrapper.swift
//  TextValidator
//
//  Created by Alfian on 09/10/24.
//

import SwiftUI

struct NavigationControllerWrapper: UIViewControllerRepresentable {
    let coordinator: any Coordinator

    public init(coordinator: any Coordinator) {
        self.coordinator = coordinator
    }

    public func makeUIViewController(context _: Context) -> UINavigationController {
        return coordinator.navigationController
    }

    public func updateUIViewController(_: UINavigationController, context _: Context) {
        // Handle updates if necessary
    }
}
