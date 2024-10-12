//
//  Coordinator.swift
//  TextValidator
//
//  Created by Alfian on 04/10/24.
//

import SwiftUI

protocol Router: ObservableObject {
	associatedtype Page: Hashable
	associatedtype Sheet
	associatedtype Fullscreen
	
	var path: NavigationPath { get set }
	var sheet: Sheet? { get set }
	var fullscreen: Fullscreen? { get set }
	
	func push(_ page: Page)
	func pop()
	func popToRoot()
	func present(_ sheet: Sheet)
	func dismissSheet()
	func present(_ fullscreen: Fullscreen)
	func dismissFullscreen()
}

extension Router {
	func push(_ page: Page) {
		path.append(page)
	}
	
	func pop() {
		path.removeLast()
	}
	
	func popToRoot() {
		path.removeLast(path.count)
	}
	
	func present(_ sheet: Sheet) {
		self.sheet = sheet
	}
	
	func dismissSheet() {
		sheet = nil
	}
	
	func present(_ fullscreen: Fullscreen) {
		self.fullscreen = fullscreen
	}
	
	func dismissFullscreen() {
		fullscreen = nil
	}
}
