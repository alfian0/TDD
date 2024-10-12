//
//  FilterCountryCodesUsecaseTest.swift
//  TextValidator
//
//  Created by Alfian on 07/10/24.
//

import XCTest
@testable import TextValidator

final class FilterCountryCodesUsecaseTest: XCTestCase {
	func test_FilterCountryCodesUsecase_withEmptySearchText_shouldBeReturnAll() {
		let _countries = [
			.dummy,
			CountryCodeModel(name: "Afghanistan", flag: "🇦🇫", dialCode: "+93", code: "AF"),
			CountryCodeModel(name: "Bahamas", flag: "🇧🇸", dialCode: "+1242", code: "BS")
		]
		let sut = FilterCountryCodesUsecase()
		let countries = sut.execute(input: .init(
			search: "",
			items: _countries,
			selected: .dummy)
		)
		
		XCTAssertEqual(countries.count, _countries.count)
	}
	
	func test_FilterCountryCodesUsecase_withValidSearchText_shouldBeReturnAll() {
		let _countries = [
			.dummy,
			CountryCodeModel(name: "Afghanistan", flag: "🇦🇫", dialCode: "+93", code: "AF"),
			CountryCodeModel(name: "Bahamas", flag: "🇧🇸", dialCode: "+1242", code: "BS")
		]
		let sut = FilterCountryCodesUsecase()
		let countries = sut.execute(input: .init(
			search: "afg",
			items: _countries,
			selected: .dummy)
		)
		
		XCTAssertEqual(countries.count, 2)
		XCTAssertEqual(countries[0].name, "Indonesia")
		XCTAssertEqual(countries[1].name, "Afghanistan")
	}
}
