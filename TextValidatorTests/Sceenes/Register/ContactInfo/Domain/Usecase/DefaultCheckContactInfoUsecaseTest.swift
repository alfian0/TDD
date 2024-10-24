//
//  DefaultCheckContactInfoUsecaseTest.swift
//  TextValidator
//
//  Created by Alfian on 07/10/24.
//

import Combine
@testable import TextValidator
import XCTest

// final class DefaultCheckContactInfoUsecaseTest: XCTestCase {
//    var cancellables = Set<AnyCancellable>()
//
//    func test_DefaultCheckContactInfoRepository_withMockSuccessLevelOne_shouldReturnAccountLevelOne() {
//        let expectation = expectation(description: "Should return level one")
//        let service = MockCheckContactInfoService()
//        service.result = ContactInfoResponse(type: "one")
//        let sut = VerifyPhoneUsecase(service: service)
//        sut.execute(fullname: "", phone: "")
//            .sink { result in
//                switch result {
//                case let .success(level):
//                    XCTAssertEqual(level, AccountLevel.one)
//                    expectation.fulfill()
//                case .failure:
//                    XCTFail()
//                }
//            }
//            .store(in: &cancellables)
//        wait(for: [expectation])
//    }
//
//    func test_DefaultCheckContactInfoRepository_withMockError_shouldReturnError() {
//        let expectation = expectation(description: "Should return error")
//        let service = MockCheckContactInfoService()
//        service.error = NSError(domain: "", code: 404)
//        let sut = VerifyPhoneUsecase(service: service)
//        sut.execute(fullname: "", phone: "")
//            .sink { result in
//                switch result {
//                case .success:
//                    XCTFail()
//                case let .failure(error):
//                    XCTAssertEqual(error, ContactInfoError.NETWORK_ERROR(NSError(domain: "", code: 404)))
//                    expectation.fulfill()
//                }
//            }
//            .store(in: &cancellables)
//        wait(for: [expectation])
//    }
//
//    func test_DefaultCheckContactInfoRepository_withMockError_shouldReturnAlreadyRegistered() {
//        let expectation = expectation(description: "Should return registered")
//        let service = MockCheckContactInfoService()
//        service.error = NSError(domain: "", code: 403)
//        let sut = VerifyPhoneUsecase(service: service)
//        sut.execute(fullname: "", phone: "")
//            .sink { result in
//                switch result {
//                case .success:
//                    XCTFail()
//                case let .failure(error):
//                    XCTAssertEqual(error, ContactInfoError.ALREADY_REGISTERED)
//                    expectation.fulfill()
//                }
//            }
//            .store(in: &cancellables)
//        wait(for: [expectation])
//    }
// }
