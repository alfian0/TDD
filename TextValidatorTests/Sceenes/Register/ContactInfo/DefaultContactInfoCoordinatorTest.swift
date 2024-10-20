//
//  DefaultContactInfoCoordinatorTest.swift
//  TextValidator
//
//  Created by Alfian on 09/10/24.
//

import SwiftUI
@testable import TextValidator
import XCTest

// class DefaultContactInfoCoordinatorTest: XCTestCase {
//    var coordinator: DefaultContactInfoCoordinator!
//    var mockNavController: MockNavigationController!
//
//    override func setUp() {
//        super.setUp()
//        mockNavController = MockNavigationController()
//        coordinator = DefaultContactInfoCoordinator(navigationController: mockNavController)
//    }
//
//    override func tearDown() {
//        mockNavController = nil
//        coordinator = nil
//        super.tearDown()
//    }
//
//    func testStart_whenNavigationStackIsEmpty_shouldPushContactInfoView() {
//        // Given
//        XCTAssertTrue(mockNavController.viewControllers.isEmpty)
//
//        // When
//        coordinator.start()
//
//        // Then
//        XCTAssertNotNil(mockNavController.pushViewController)
//        XCTAssertTrue(mockNavController.pushViewController is UIHostingController<ContactInfoView>)
//    }
//
//    func testPushOTP_shouldStartOTPCoordinator() {
//        // When
//        coordinator.push(.otp(type: .phone(code: .dummy, phone: "")))
//
//        // Then
//        XCTAssertNotNil(mockNavController.pushViewController)
//        XCTAssertTrue(mockNavController.pushViewController is UIHostingController<OTPView>)
//    }
//
//    func testPresentErrorSheet_shouldPresentErrorCoordinator() {
//        // When
//        coordinator.present(.error(title: "Error", subtitle: "Something went wrong", didDismiss: {}))
//
//        // Then
//        XCTAssertNotNil(mockNavController.presentViewController)
//        XCTAssertTrue((mockNavController.presentViewController as? UINavigationController)?.viewControllers.first is UIHostingController<ErrorView>)
//    }
//
//    func testPresentLoginSheet_shouldPresentLoginCoordinator() {
//        // When
//        coordinator.present(.login)
//
//        // Then
//        XCTAssertNotNil(mockNavController.presentViewController)
//        XCTAssertTrue((mockNavController.presentViewController as? UINavigationController)?.viewControllers.first is UIHostingController<LoginView>)
//    }
//
//    func testPresentCountryCode_shouldPresentCountryCodeCoordinator() {
//        // When
//        coordinator.present(.countryCode(selected: .dummy, items: [.dummy], didSelect: { _ in
//
//        }, didDismiss: {}))
//
//        // Then
//        XCTAssertNotNil(mockNavController.presentViewController)
//        XCTAssertTrue((mockNavController.presentViewController as? UINavigationController)?.viewControllers.first is UIHostingController<CountrySearchListView>)
//    }
// }
