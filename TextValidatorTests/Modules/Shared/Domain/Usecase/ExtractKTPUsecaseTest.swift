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
        let sut = makeSUT(image: invalidImage())
        let result = await sut.exec()
        switch result {
        case .success:
            XCTFail()
        case let .failure(error):
            XCTAssertEqual(error, ExtractKTPUsecaseError.invalidKTP)
        }
    }

    func test_extractKTP_withValidImage_shouldReturnData() async {
        let sut = makeSUT(image: image())
        let result = await sut.exec()
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
        let sut = makeSUT(image: image2())
        let result = await sut.exec()
        switch result {
        case let .success(data):
            XCTAssertEqual(data.nik, "3506042602660001")
            XCTAssertEqual(data.pob, "KEDIRI")
            XCTAssertEqual(data.dob, "26-02-1966".toDate(dateFormat: OCRDateFormat.ktp))
        case .failure:
            XCTFail()
        }
    }

    func test_extractKTP_withValidImage_shouldReturnData3() async {
        let sut = makeSUT(image: image3())
        let result = await sut.exec()
        switch result {
        case let .success(data):
            XCTAssertEqual(data.nama, "RIYANIO  SE")
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

    private func makeSUT(image: UIImage) -> ExtractKTPUsecase {
        let documentScannerRepository = MockDocumentScanner()
        documentScannerRepository.result = image

        return ExtractKTPUsecase(
            documentScannerRepository: documentScannerRepository,
            ocrKTPUsecase: OCRKTPUsecase(visionService: VisionService()),
            cropKTPUseCase: CropKTPUseCase(visionService: VisionService()),
            classifiedKTPUsecase: ClassifiedKTPUsecase(visionService: VisionService()),
            extractNIKUsecase: ExtractNIKUsecase(nikUsecase: NIKValidationUsecase()),
            extractNameUsecase: ExtractNameUsecase(),
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

final class MockDocumentScanner: CameraCaptureRepository {
    var result: UIImage?
    var error: NSError?

    func getCapturedImage() async throws -> UIImage {
        guard let result = result else {
            throw error ?? NSError(domain: "", code: 404)
        }

        return result
    }
}
