//
//  DataExtensionTest.swift
//  TextValidator
//
//  Created by Alfian on 02/10/24.
//

@testable import TextValidator
import XCTest

final class DataExtensionTest: XCTestCase {
    func test_DataExtension_withValidFilename_shouldSuccess() {
        do {
            let sut = try Data.fromJSONFile("Dial")
            XCTAssertTrue(!sut.isEmpty)
        } catch {
            XCTFail()
        }
    }

    func test_DataExtension_withInvalidFilename_shouldFailed() {
        do {
            let _ = try Data.fromJSONFile("Not Valid Filename")
            XCTFail()
        } catch {
            XCTAssertEqual(error as NSError, NSError(domain: "fromJSONFile", code: 404))
        }
    }

    func test_DataExtension_convertToDecodableWithValidCast_shouldSuccess() {
        do {
            let data = try Data.fromJSONFile("Dial")
            let sut = try data.toCodable(with: [CountryCodeResponse].self)
            XCTAssertEqual(sut.count, 246)
            XCTAssertEqual(sut.first?.name, "Afghanistan")
            XCTAssertEqual(sut.first?.flag, "🇦🇫")
            XCTAssertEqual(sut.first?.code, "AF")
            XCTAssertEqual(sut.first?.dialCode, "+93")
        } catch {
            XCTFail()
        }
    }

    func test_DataExtension_convertToDecodableWithInvalidCast_shouldSuccess() {
        do {
            let data = try Data.fromJSONFile("Dial")
            let _ = try data.toCodable(with: CountryCodeResponse.self)
            XCTFail()
        } catch {
            XCTAssertEqual(error as NSError, NSError(domain: "toCodable", code: 404))
        }
    }

    func test_DataExtension_convertToStringWithValidJSON_shouldSuccess() {
        do {
            let data = try Data.fromJSONFile("Dial")
            let jsonString = try data.toString()
            XCTAssertTrue(!jsonString.isEmpty)
        } catch {
            XCTFail()
        }
    }
}
