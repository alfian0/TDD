//
//  FullNameValidationUsecaseTest.swift
//  TextValidator
//
//  Created by Alfian on 07/10/24.
//

@testable import TextValidator
import XCTest

final class FullNameValidationUsecaseTest: XCTestCase {
    func test_FullNameValidationUsecase_withEmptyText_shouldBeReturnError() {
        let sut = NameValidationUsecase()
        let error = sut.execute(input: "")
        XCTAssertEqual(error, TextValidationError.empty)
    }

    func test_FullNameValidationUsecase_withShortText_shouldBeReturnError() {
        let sut = NameValidationUsecase()
        let error = sut.execute(input: "A")
        XCTAssertEqual(error, TextValidationError.tooShort)
    }

    func test_FullNameValidationUsecase_withLongText_shouldBeReturnError() {
        let sut = NameValidationUsecase()
        let error = sut.execute(input: "AAAAAAAAAAAAAAAAAAAAA")
        XCTAssertEqual(error, TextValidationError.tooLong)
    }

    func test_FullNameValidationUsecase_withValidText_shouldBeReturnError() {
        let sut = NameValidationUsecase()
        let error = sut.execute(input: "Valid Name")
        XCTAssertNil(error)
    }
}
