//
//  Coordinator.swift
//  TextValidator
//
//  Created by Alfian on 09/10/24.
//

import SwiftUI

public protocol Coordinator: AnyObject {
    var childCoordinator: [any Coordinator] { get set }
    var navigationController: UINavigationController { get set }
}
