//
//  VisionRepositoryImplTest.swift
//  TextValidator
//
//  Created by Alfian on 20/10/24.
//

@testable import TextValidator
import XCTest

final class VisionRepositoryImplTest: XCTestCase {
    func test_textRecognizer_withValidIDCard_shouldReturnValidData() async throws {
        let sut = MachineLearningRepositoryImpl(visionService: VisionService())
        let data = try await sut.textRecognizer(image: image())
        XCTAssertEqual(data.count, 31)
    }

    func test_textRecognizer_withValidIDCard_shouldReturnValidData2() async throws {
        let sut = MachineLearningRepositoryImpl(visionService: VisionService())
        let data = try await sut.textRecognizer(image: image2())
        XCTAssertEqual(data.count, 20)
    }

    func test_textRecognizer_withValidIDCard_shouldReturnValidData3() async throws {
        let sut = MachineLearningRepositoryImpl(visionService: VisionService())
        let data = try await sut.textRecognizer(image: image3())
        XCTAssertEqual(data.count, 28)
    }
}
