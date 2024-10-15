//
//  ContactInfoViewModelTest.swift
//  TextValidator
//
//  Created by Alfian on 08/10/24.
//

import Combine
@testable import TextValidator
import XCTest

final class ContactInfoViewModelTest: XCTestCase {
    var sut: ContactInfoViewModel! // system under test
    var countryCodeRepo: MockCountryCodeRepository!
    var checkContactInfoRepo: MockCheckContactInfoRepository!
    var spyCoordinator: SpyContactInfoCoordinator!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        countryCodeRepo = MockCountryCodeRepository()
        checkContactInfoRepo = MockCheckContactInfoRepository()
        spyCoordinator = SpyContactInfoCoordinator()
        cancellables = []

        sut = ContactInfoViewModel(
            fullnameValidationUsecase: NameValidationUsecase(),
            phoneValidationUsecase: PhoneValidationUsecase(),
            countryCodeUsecase: countryCodeRepo,
            checkContactInfoUsecase: checkContactInfoRepo,
            coordinator: spyCoordinator
        )
    }

    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        sut = nil
        super.tearDown()
    }

    func test_ContactInfoViewModel_withInit() {
        XCTAssertNil(sut.fullnameError)
        XCTAssertNil(sut.phoneError)
        XCTAssertFalse(sut.isLoading)
    }

    func test_ContactInfoViewModel_withEmptyFullname_shouldReturnFullnameError() {
        sut.fullname = ""

        XCTAssertEqual(sut.fullnameError, "Empty")
    }

    func test_ContactInfoViewModel_withEmptyPhone_shouldReturnPhoneError() {
        sut.phone = ""

        XCTAssertEqual(sut.phoneError, "Invalid format")
    }

    func test_ContactInfoViewModel_withInvalidFullname_shouldReturnCanSubmitFalse() {
        sut.fullname = ""
        sut.phone = "88888888"
        sut.isAgreeToTnC = true

        XCTAssertFalse(sut.canSubmit)
    }

    func test_ContactInfoViewModel_withInvalidPhone_shouldReturnCanSubmitFalse() {
        sut.fullname = "Valid Name"
        sut.phone = ""
        sut.isAgreeToTnC = true

        XCTAssertFalse(sut.canSubmit)
    }

    func test_ContactInfoViewModel_withInvalidAgree_shouldReturnCanSubmitFalse() {
        sut.fullname = "Valid Name"
        sut.phone = "88888888"
        sut.isAgreeToTnC = false

        XCTAssertFalse(sut.canSubmit)
    }

    func test_ContactInfoViewModel_withInvalid_shouldReturnCanSubmitTrue() {
        sut.fullname = "Valid Name"
        sut.phone = "88888888"
        sut.isAgreeToTnC = true

        XCTAssertTrue(sut.canSubmit)
    }

    func test_ContactInfoViewModel_withCancel_shouldReturnNil() {
        sut.cancel()
        XCTAssertEqual(sut.cancellables.count, 0)
    }

    func testDidTapCountryCode_whenCountryCodesAvailable_shouldPresentCountryCode() {
        // Given
        sut.countryCodes = [.dummy] // Assume country codes are already fetched

        // When
        sut.didTapCountryCode()

        // Then
        XCTAssertTrue(spyCoordinator.didPresentCountryCode, "The coordinator should present the country code selection sheet.")
    }

    func testDidTapCountryCode_whenCountryCodesNotAvailable_shouldFetchAndPresent() {
        // Given
        let expectedCountryCodes = [CountryCodeModel.dummy]
        countryCodeRepo.result = expectedCountryCodes

        // When
        sut.didTapCountryCode()

        // Then
        // Expect country codes to be set after fetching
        sut.$countryCodes
            .dropFirst()
            .sink { countryCodes in
                XCTAssertEqual(countryCodes, expectedCountryCodes)
                XCTAssertTrue(self.spyCoordinator.didPresentCountryCode)
            }
            .store(in: &cancellables)
    }

    func testDidTapContinue_whenCheckContactInfoSucceeds_shouldPushCorrectCoordinatorPage() {
        // Given
        checkContactInfoRepo.result = .one
        sut.fullname = "Test Name"
        sut.phone = "123456789"

        // When
        sut.didTapCountinue()

        // Then
        sut.$isLoading
            .dropFirst()
            .sink { isLoading in
                XCTAssertFalse(isLoading)
                XCTAssertTrue(self.spyCoordinator.didPushOTP, "The coordinator should push the OTP page.")
            }
            .store(in: &cancellables)
    }

    func testDidTapContinue_whenCheckContactInfoSucceeds_shouldPushCorrectCoordinatorPage2() {
        // Given
        checkContactInfoRepo.result = .two
        sut.fullname = "Test Name"
        sut.phone = "123456789"

        // When
        sut.didTapCountinue()

        // Then
        sut.$isLoading
            .dropFirst()
            .sink { isLoading in
                XCTAssertFalse(isLoading)
                XCTAssertTrue(self.spyCoordinator.didPushOTP, "The coordinator should push the Email page.")
            }
            .store(in: &cancellables)
    }

    func testDidTapContinue_whenCheckContactInfoFails_shouldPresentError() {
        // Given
        checkContactInfoRepo.error = .UNKNOWN
        sut.fullname = "Test Name"
        sut.phone = "123456789"

        // When
        sut.didTapCountinue()

        // Then
        sut.$isLoading
            .dropFirst()
            .sink { isLoading in
                XCTAssertFalse(isLoading)
                XCTAssertTrue(self.spyCoordinator.didPresentError, "The coordinator should present an error sheet.")
            }
            .store(in: &cancellables)
    }

    func testLaunchLogin_shouldPushCorrectCoordinatorPage() {
        sut.launchLogin()

        XCTAssertTrue(spyCoordinator.didPresentLogin, "The coordinator should present the Login page.")
    }
}
