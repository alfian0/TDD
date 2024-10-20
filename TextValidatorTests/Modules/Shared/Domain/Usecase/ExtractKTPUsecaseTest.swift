//
//  ExtractKTPUsecaseTest.swift
//  TextValidator
//
//  Created by Alfian on 20/10/24.
//

@testable import TextValidator
import XCTest

final class ExtractKTPUsecaseTest: XCTestCase {
    func test_extractKTP_withValidImage_shouldReturnData() async {
        let sut = ExtractKTPUsecase(repository: VisionRepositoryImpl(visionService: VisionService()))
        let result = await sut.exec(image: image())
        switch result {
        case let .success(data):
            XCTAssertEqual(data.nama, "ANGGI PRATAMA")
            XCTAssertEqual(data.nik, "3403162806030001")
            XCTAssertEqual(data.pob, "WONOGIRI")
            XCTAssertEqual(data.dob, "28-06-2003".toDate(dateFormat: "dd-MM-yyyy"))
            XCTAssertEqual(data.gender, GenderType.LakiLaki)
            XCTAssertEqual(data.job, JobType.NelayanPerikanan)
            XCTAssertEqual(data.religion, ReligionType.Islam)
            XCTAssertEqual(data.marriedStatus, MarriedStatusType.BelumKawin)
            XCTAssertEqual(data.nationality, NationalityType.wni)
        case .failure:
            XCTFail()
        }
    }

    func test_extractKTP_withValidImage_shouldReturnData2() async {
        let sut = ExtractKTPUsecase(repository: VisionRepositoryImpl(visionService: VisionService()))
        let result = await sut.exec(image: image2())
        switch result {
        case let .success(data):
//            XCTAssertEqual(data.nama, "ANGGI PRATAMA")
            XCTAssertEqual(data.nik, "3203012503770011")
//            XCTAssertEqual(data.pob, "WONOGIRI")
//            XCTAssertEqual(data.dob, "28-06-2003".toDate(dateFormat: "dd-MM-yyyy"))
//            XCTAssertEqual(data.gender, GenderType.LakiLaki)
//            XCTAssertEqual(data.job, JobType.NelayanPerikanan)
//            XCTAssertEqual(data.religion, ReligionType.Islam)
//            XCTAssertEqual(data.marriedStatus, MarriedStatusType.BelumKawin)
//            XCTAssertEqual(data.nationality, NationalityType.wni)
        case .failure:
            XCTFail()
        }
    }
}
