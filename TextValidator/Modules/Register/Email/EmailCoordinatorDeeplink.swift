//
//  EmailCoordinatorDeeplink.swift
//  TextValidator
//
//  Created by Alfian on 16/10/24.
//

import SwiftUI

final class EmailCoordinatorDeeplink: EmailCoordinator {
    private let wrapped: EmailCoordinator

    var childCoordinator: [any Coordinator] {
        get { wrapped.childCoordinator }
        set { wrapped.childCoordinator = newValue }
    }

    var navigationController: UINavigationController {
        get { wrapped.navigationController }
        set { wrapped.navigationController = newValue }
    }

    init(wrapped: EmailCoordinator) {
        self.wrapped = wrapped
    }

    @MainActor
    func start(_ deeplink: DeeplinkType) async {
        switch deeplink {
        case let .verifyEmail(link):
            await start(viewState: .waitingForVerification(link: link))
        }
    }

    @MainActor
    func start(viewState: EmailViewState) async {
        await wrapped.start(viewState: viewState)
    }

    @MainActor
    func push(_ page: EmailCoordinatorPage) async {
        await wrapped.push(page)
    }

    func present(_ sheet: EmailCoordinatorSheet) {
        wrapped.present(sheet)
    }
}
