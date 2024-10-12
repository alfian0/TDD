//
//  FullNameValidationUsecaseTest.swift
//  TextValidator
//
//  Created by Alfian on 07/10/24.
//

import XCTest
@testable import TextValidator

final class FullNameValidationUsecaseTest: XCTestCase {
	func test_FullNameValidationUsecase_withEmptyText_shouldBeReturnError() {
		let sut = FullNameValidationUsecase()
		let error = sut.execute(input: "")
		XCTAssertEqual(error, TextValidationError.EMPTY)
	}
	
	func test_FullNameValidationUsecase_withShortText_shouldBeReturnError() {
		let sut = FullNameValidationUsecase()
		let error = sut.execute(input: "A")
		XCTAssertEqual(error, TextValidationError.TOO_SHORT)
	}
	
	func test_FullNameValidationUsecase_withLongText_shouldBeReturnError() {
		let sut = FullNameValidationUsecase()
		let error = sut.execute(input: "AAAAAAAAAAAAAAAAAAAAA")
		XCTAssertEqual(error, TextValidationError.TOO_LONG)
	}
	
	func test_FullNameValidationUsecase_withValidText_shouldBeReturnError() {
		let sut = FullNameValidationUsecase()
		let error = sut.execute(input: "Valid Name")
		XCTAssertNil(error)
	}
}
