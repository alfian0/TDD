//
//  MockNavigationController.swift
//  TextValidator
//
//  Created by Alfian on 09/10/24.
//

import UIKit

class MockNavigationController: UINavigationController {
    var pushViewController: UIViewController?
    var presentViewController: UIViewController?
    var dismissedCalled = false

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushViewController = viewController
        super.pushViewController(viewController, animated: animated)
    }

    override func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        presentViewController = viewController
        super.present(viewController, animated: animated, completion: completion)
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismissedCalled = true
        super.dismiss(animated: flag, completion: completion)
    }

    override func show(_ vc: UIViewController, sender: Any?) {
        pushViewController = vc
        super.show(vc, sender: sender)
    }

    override func showDetailViewController(_ vc: UIViewController, sender _: Any?) {
        presentViewController = vc
        super.present(vc, animated: true, completion: nil)
    }
}
