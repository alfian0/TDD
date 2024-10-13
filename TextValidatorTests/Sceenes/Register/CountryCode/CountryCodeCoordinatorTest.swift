//
//  CountryCodeCoordinatorTest.swift
//  TextValidator
//
//  Created by Alfian on 09/10/24.
//

import SwiftUI
@testable import TextValidator
import XCTest

class CountryCodeCoordinatorTest: XCTestCase {
    var coordinator: CountryCodeCoordinator!
    var mockNavController: MockNavigationController!

    override func setUp() {
        super.setUp()
        mockNavController = MockNavigationController()
        coordinator = CountryCodeCoordinator(navigationController: mockNavController)
    }

    override func tearDown() {
        mockNavController = nil
        coordinator = nil
        super.tearDown()
    }

    func testStart_whenNavigationStackIsEmpty_shouldPushContactInfoView() {
        // Given
        XCTAssertTrue(mockNavController.viewControllers.isEmpty)

        // When
        coordinator.start(selected: .dummy, items: [], didSelect: { _ in

        }, didDismiss: {})

        // Then
        XCTAssertNotNil(mockNavController.pushViewController)
        XCTAssertTrue(mockNavController.pushViewController is UIHostingController<CountrySearchListView>)
    }
}
