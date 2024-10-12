//
//  TextValidatorApp.swift
//  TextValidator
//
//  Created by Alfian on 30/09/24.
//

import SwiftUI

@main
struct TextValidatorApp: App {
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
