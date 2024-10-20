//
//  VerifyPINUsecaseTest.swift
//  TextValidator
//
//  Created by Alfian on 12/10/24.
//

import Combine
@testable import TextValidator
import XCTest

// final class VerifyPINUsecaseTest: XCTestCase {
//    var cancellables = Set<AnyCancellable>()
//
//    func test_VerifyPINUsecase_withEmptyText_shoudReturnEmpty() {
//        let expectation = expectation(description: "Should return empty")
//        let service = MockSetPINService()
//        let sut = PINValidationUsecase(service: service)
//        sut.execute(pin: "", repin: "")
//            .sink { result in
//                switch result {
//                case .success:
//                    XCTFail()
//                case let .failure(error):
//                    switch error {
//                    case let .TEXT_ERROR(error):
//                        XCTAssertEqual(error, TextValidationError.EMPTY)
//                        expectation.fulfill()
//                    case .NETWORK_ERROR:
//                        XCTFail()
//                    }
//                }
//            }
//            .store(in: &cancellables)
//
//        wait(for: [expectation])
//    }
//
//    func test_VerifyPINUsecase_withUnder4Characther_shoudReturnTooShort() {
//        let expectation = expectation(description: "Should return TOO_SHORT")
//        let service = MockSetPINService()
//        let sut = PINValidationUsecase(service: service)
//        sut.execute(pin: "123", repin: "")
//            .sink { result in
//                switch result {
//                case .success:
//                    XCTFail()
//                case let .failure(error):
//                    switch error {
//                    case let .TEXT_ERROR(error):
//                        XCTAssertEqual(error, TextValidationError.TOO_SHORT)
//                        expectation.fulfill()
//                    case .NETWORK_ERROR:
//                        XCTFail()
//                    }
//                }
//            }
//            .store(in: &cancellables)
//
//        wait(for: [expectation])
//    }
//
//    func test_VerifyPINUsecase_withOver12Characther_shoudReturnTooLong() {
//        let expectation = expectation(description: "Should return TOO_LONG")
//        let service = MockSetPINService()
//        let sut = PINValidationUsecase(service: service)
//        sut.execute(pin: "1234567890123", repin: "")
//            .sink { result in
//                switch result {
//                case .success:
//                    XCTFail()
//                case let .failure(error):
//                    switch error {
//                    case let .TEXT_ERROR(error):
//                        XCTAssertEqual(error, TextValidationError.TOO_LONG)
//                        expectation.fulfill()
//                    case .NETWORK_ERROR:
//                        XCTFail()
//                    }
//                }
//            }
//            .store(in: &cancellables)
//
//        wait(for: [expectation])
//    }
//
//    func test_VerifyPINUsecase_withIdenticalConsecutive_shoudReturnIDENTICAL_CONSECUTIVE() {
//        let expectation = expectation(description: "Should return IDENTICAL_CONSECUTIVE")
//        let service = MockSetPINService()
//        let sut = PINValidationUsecase(service: service)
//        sut.execute(pin: "1111", repin: "")
//            .sink { result in
//                switch result {
//                case .success:
//                    XCTFail()
//                case let .failure(error):
//                    switch error {
//                    case let .TEXT_ERROR(error):
//                        XCTAssertEqual(error, TextValidationError.IDENTICAL_CONSECUTIVE)
//                        expectation.fulfill()
//                    case .NETWORK_ERROR:
//                        XCTFail()
//                    }
//                }
//            }
//            .store(in: &cancellables)
//
//        wait(for: [expectation])
//    }
//
//    func test_VerifyPINUsecase_withSquential_shoudReturnIDENTICAL_CANNOT_SQUENTIAL() {
//        let expectation = expectation(description: "Should return CANNOT_SQUENTIAL")
//        let service = MockSetPINService()
//        let sut = PINValidationUsecase(service: service)
//        sut.execute(pin: "123456", repin: "")
//            .sink { result in
//                switch result {
//                case .success:
//                    XCTFail()
//                case let .failure(error):
//                    switch error {
//                    case let .TEXT_ERROR(error):
//                        XCTAssertEqual(error, TextValidationError.CANNOT_SQUENTIAL)
//                        expectation.fulfill()
//                    case .NETWORK_ERROR:
//                        XCTFail()
//                    }
//                }
//            }
//            .store(in: &cancellables)
//
//        wait(for: [expectation])
//    }
//
//    func test_VerifyPINUsecase_withValidPin_shoudReturnisVerifyFALSE() {
//        let expectation = expectation(description: "Should return isVerify FALSE")
//        let service = MockSetPINService()
//        let sut = PINValidationUsecase(service: service)
//        sut.execute(pin: "123458", repin: "")
//            .sink { result in
//                switch result {
//                case let .success(isVerify):
//                    XCTAssertFalse(isVerify)
//                    expectation.fulfill()
//                case let .failure(error):
//                    switch error {
//                    case .TEXT_ERROR:
//                        XCTFail()
//                    case .NETWORK_ERROR:
//                        XCTFail()
//                    }
//                }
//            }
//            .store(in: &cancellables)
//
//        wait(for: [expectation])
//    }
//
//    func test_VerifyPINUsecase_withValidPinAndRepin_shoudReturnisVerifyTRUE() {
//        let expectation = expectation(description: "Should return isVerify TRUE")
//        let service = MockSetPINService()
//        let sut = PINValidationUsecase(service: service)
//        sut.execute(pin: "123458", repin: "123458")
//            .sink { result in
//                switch result {
//                case let .success(isVerify):
//                    XCTAssertTrue(isVerify)
//                    expectation.fulfill()
//                case let .failure(error):
//                    switch error {
//                    case .TEXT_ERROR:
//                        XCTFail()
//                    case .NETWORK_ERROR:
//                        XCTFail()
//                    }
//                }
//            }
//            .store(in: &cancellables)
//
//        wait(for: [expectation])
//    }
//
//    func test_VerifyPINUsecase_withValidPinAndNotValidRepin_shoudReturnNOT_EQUAL() {
//        let expectation = expectation(description: "Should return NOT_EQUAL")
//        let service = MockSetPINService()
//        let sut = PINValidationUsecase(service: service)
//        sut.execute(pin: "123458", repin: "123454")
//            .sink { result in
//                switch result {
//                case .success:
//                    XCTFail()
//                case let .failure(error):
//                    switch error {
//                    case let .TEXT_ERROR(error):
//                        XCTAssertEqual(error, TextValidationError.NOT_EQUAL)
//                        expectation.fulfill()
//                    case .NETWORK_ERROR:
//                        XCTFail()
//                    }
//                }
//            }
//            .store(in: &cancellables)
//
//        wait(for: [expectation])
//    }
//
//    func test_VerifyPINUsecase_withNetworkError_shoudReturnNetworkError() {
//        let expectation = expectation(description: "Should return Network Error")
//        let service = MockSetPINService()
//        service.error = NSError(domain: "", code: 404)
//        let sut = PINValidationUsecase(service: service)
//        sut.execute(pin: "123457", repin: "123457")
//            .sink { result in
//                switch result {
//                case .success:
//                    XCTFail()
//                case let .failure(error):
//                    switch error {
//                    case .TEXT_ERROR:
//                        XCTFail()
//                    case let .NETWORK_ERROR(error):
//                        XCTAssertEqual((error as NSError).code, 404)
//                        expectation.fulfill()
//                    }
//                }
//            }
//            .store(in: &cancellables)
//
//        wait(for: [expectation])
//    }
// }
