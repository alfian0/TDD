//
//  VisionServiceTest.swift
//  TextValidator
//
//  Created by Alfian on 20/10/24.
//

@testable import TextValidator
import XCTest

final class VisionServiceTest: XCTestCase {
    func test_textRecognizer_withValidIDCard_shouldReturnValidData() async throws {
        let sut = VisionService()
        let data = try await sut.textRecognizer(image: image())
        XCTAssertTrue(data.count > 0)
    }

    func test_textRecognizer_withValidIDCard_shouldReturnValidData2() async throws {
        let sut = VisionService()
        let data = try await sut.textRecognizer(image: image2())
        XCTAssertTrue(data.count > 0)
    }

    func test_textRecognizer_withInValidIDCard_shouldReturnError() async throws {
        let sut = VisionService()
        let data = try await sut.textRecognizer(image: invalidImage())
        XCTAssertEqual(data.count, 0)
    }
}
