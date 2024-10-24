//
//  PhoneValidationUsecaseTest.swift
//  TextValidator
//
//  Created by Alfian on 07/10/24.
//

@testable import TextValidator
import XCTest

final class PhoneValidationUsecaseTest: XCTestCase {
    func test_PhoneValidationUsecase_withEmptyText_shouldReturnError() {
        let sut = PhoneValidationUsecase()
        let error = sut.execute(input: "")
        XCTAssertEqual(error, TextValidationError.empty)
    }

    func test_PhoneValidationUsecase_withLessThan5Text_shouldReturnError() {
        let sut = PhoneValidationUsecase()
        let error = sut.execute(input: "087")
        XCTAssertEqual(error, TextValidationError.tooShort)
    }

    func test_PhoneValidationUsecase_withInvalidText_shouldReturnError() {
        let sut = PhoneValidationUsecase()
        let error = sut.execute(input: "087738091779")
        XCTAssertEqual(error, TextValidationError.invalidFormat)
    }

    func test_PhoneValidationUsecase_withValidText_shouldReturnError() {
        let sut = PhoneValidationUsecase()
        let error = sut.execute(input: "+6287738091779")
        XCTAssertNil(error)
    }
}
