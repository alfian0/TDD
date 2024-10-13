//
//  DefaultCountryCodeUsecaseTest.swift
//  TextValidator
//
//  Created by Alfian on 07/10/24.
//

import Combine
@testable import TextValidator
import XCTest

final class DefaultCountryCodeUsecaseTest: XCTestCase {
    var cancellables = Set<AnyCancellable>()

    func test_GetCountryCodeRepository_withMockSuccess_shouldReturnSuccess() {
        let expectation = expectation(description: "Should return success")
        let service = MockCountryCodeService()
        service.result = try! Data.fromJSONFile("Dial").toCodable(with: [CountryCodeResponse].self)
        let sut = DefaultCountryCodeUsecase(service: service)
        sut.execute()
            .sink { result in
                switch result {
                case let .success(data):
                    XCTAssertEqual(data.count, 246)
                    expectation.fulfill()
                case .failure:
                    XCTFail()
                }
            }
            .store(in: &cancellables)

        wait(for: [expectation])
    }

    func test_GetCountryCodeRepository_withMockError_shouldReturnError() {
        let expectation = expectation(description: "Should return error")
        let service = MockCountryCodeService()
        service.error = NSError(domain: "", code: 404)
        let sut = DefaultCountryCodeUsecase(service: service)
        sut.execute()
            .sink { result in
                switch result {
                case .success:
                    XCTFail()
                case let .failure(error):
                    XCTAssertEqual(error, CountryCodeError.ERROR_PARSE_JSON)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        wait(for: [expectation])
    }
}
