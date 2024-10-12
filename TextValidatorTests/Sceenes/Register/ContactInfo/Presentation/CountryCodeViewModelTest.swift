//
//  CountryCodeViewModelTest.swift
//  TextValidator
//
//  Created by Alfian on 07/10/24.
//

import XCTest
import Combine
@testable import TextValidator

final class CountryCodeViewModelTest: XCTestCase {
	var cancellables = Set<AnyCancellable>()
	
	func test_CountryCodeViewModel() {
		let _countries = [
			.dummy,
			CountryCodeModel(name: "Afghanistan", flag: "🇦🇫", dialCode: "+93", code: "AF"),
			CountryCodeModel(name: "Bahamas", flag: "🇧🇸", dialCode: "+1242", code: "BS")
		]
		
		let sut = CountryCodeViewModel(
			selected: .dummy,
			items: _countries
		) { item in
			
		} didDismiss: {
			
		}
		
		sut.search = "Afghanistan"
		
		XCTAssertEqual(sut.selected.name, CountryCodeModel.dummy.name)
		XCTAssertEqual(sut.items, _countries)
		XCTAssertEqual(sut.filteredItems.count, 2)
		
		sut.cancel()
		XCTAssertEqual(sut.cancellables.count, 0)
	}
}
