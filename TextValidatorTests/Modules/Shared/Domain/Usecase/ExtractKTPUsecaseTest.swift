//
//  ExtractKTPUsecaseTest.swift
//  TextValidator
//
//  Created by Alfian on 20/10/24.
//

@testable import TextValidator
import XCTest

final class ExtractKTPUsecaseTest: XCTestCase {
    func test_extractKTP_withInValidImage_shouldReturnError() async {
        let sut = makeSUT()
        let result = await sut.exec(image: invalidImage())
        switch result {
        case .success:
            XCTFail()
        case let .failure(error):
            XCTAssertEqual(error, ExtractKTPUsecaseError.NOT_VALID_KTP)
        }
    }

    func test_extractKTP_withValidImage_shouldReturnData() async {
        let sut = makeSUT()
        let result = await sut.exec(image: image())
        switch result {
        case let .success(data):
            XCTAssertEqual(data.nama, "ANGGI PRATAMA")
            XCTAssertEqual(data.nik, "3403162806030001")
            XCTAssertEqual(data.pob, "WONOGIRI")
            XCTAssertEqual(data.dob, "28-06-2003".toDate(dateFormat: OCRDateFormat.ktp))
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
        let sut = makeSUT()
        let result = await sut.exec(image: image2())
        switch result {
        case let .success(data):
            XCTAssertEqual(data.nik, "3203012503770011")
            XCTAssertEqual(data.pob, "TUJIAN")
            XCTAssertEqual(data.dob, "25-03-1977".toDate(dateFormat: OCRDateFormat.ktp))
        case .failure:
            XCTFail()
        }
    }

    func test_extractKTP_withValidImage_shouldReturnData3() async {
        let sut = makeSUT()
        let result = await sut.exec(image: image3())
        switch result {
        case let .success(data):
            XCTAssertEqual(data.nama, "RIYANTO  SE")
            XCTAssertEqual(data.nik, "3471140209790001")
            XCTAssertEqual(data.pob, "GROBOGAN")
            XCTAssertEqual(data.dob, "02-09-1979".toDate(dateFormat: OCRDateFormat.ktp))
            XCTAssertEqual(data.gender, GenderType.LakiLaki)
            XCTAssertEqual(data.job, JobType.Pedagang)
            XCTAssertEqual(data.religion, ReligionType.Islam)
            XCTAssertEqual(data.marriedStatus, MarriedStatusType.Kawin)
            XCTAssertEqual(data.nationality, NationalityType.wni)
        case .failure:
            XCTFail()
        }
    }

    private func makeSUT() -> ExtractKTPUsecase {
        return ExtractKTPUsecase(
            repository: VisionRepositoryImpl(visionService: VisionService()),
            extractNIKUsecase: ExtractNIKUsecase(nikUsecase: NIKValidationUsecase()),
            extractDOBUsecase: ExtractDOBUsecase(),
            extractReligionTypeUsecase: ExtractReligionTypeUsecase(),
            extractGenderUsecase: ExtractGenderUsecase(),
            extractMaritalStatusUsecase: ExtractMaritalStatusUsecase(),
            extractJobTypeUsecase: ExtractJobTypeUsecase(),
            extractNationalityTypeUsecase: ExtractNationalityTypeUsecase(),
            candidateMatchingUsecase: CandidateMatchingUsecase()
        )
    }
}
