//
//  ExtractKTPUsecase.swift
//  TextValidator
//
//  Created by Alfian on 20/10/24.
//

import Swinject
import UIKit

class ExtractKTPUsecaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ExtractKTPUsecase.self) { r in
            guard let repository = r.resolve(VisionRepositoryImpl.self) else {
                fatalError()
            }
            guard let extractNIKUsecase = r.resolve(ExtractNIKUsecase.self) else {
                fatalError()
            }
            guard let extractDOBUsecase = r.resolve(ExtractDOBUsecase.self) else {
                fatalError()
            }
            guard let extractReligionTypeUsecase = r.resolve(ExtractReligionTypeUsecase.self) else {
                fatalError()
            }
            guard let extractGenderUsecase = r.resolve(ExtractGenderUsecase.self) else {
                fatalError()
            }
            guard let extractMaritalStatusUsecase = r.resolve(ExtractMaritalStatusUsecase.self) else {
                fatalError()
            }
            guard let extractJobTypeUsecase = r.resolve(ExtractJobTypeUsecase.self) else {
                fatalError()
            }
            guard let extractNationalityTypeUsecase = r.resolve(ExtractNationalityTypeUsecase.self) else {
                fatalError()
            }
            return ExtractKTPUsecase(
                repository: repository,
                extractNIKUsecase: extractNIKUsecase,
                extractDOBUsecase: extractDOBUsecase,
                extractReligionTypeUsecase: extractReligionTypeUsecase,
                extractGenderUsecase: extractGenderUsecase,
                extractMaritalStatusUsecase: extractMaritalStatusUsecase,
                extractJobTypeUsecase: extractJobTypeUsecase,
                extractNationalityTypeUsecase: extractNationalityTypeUsecase
            )
        }
    }
}

enum ExtractKTPUsecaseError: Error, LocalizedError {
    case UNKNOWN
}

final class ExtractKTPUsecase {
    private let repository: VisionRepositoryImpl
    private let extractNIKUsecase: ExtractNIKUsecase
    private let extractDOBUsecase: ExtractDOBUsecase
    private let extractReligionTypeUsecase: ExtractReligionTypeUsecase
    private let extractGenderUsecase: ExtractGenderUsecase
    private let extractMaritalStatusUsecase: ExtractMaritalStatusUsecase
    private let extractJobTypeUsecase: ExtractJobTypeUsecase
    private let extractNationalityTypeUsecase: ExtractNationalityTypeUsecase

    init(
        repository: VisionRepositoryImpl,
        extractNIKUsecase: ExtractNIKUsecase,
        extractDOBUsecase: ExtractDOBUsecase,
        extractReligionTypeUsecase: ExtractReligionTypeUsecase,
        extractGenderUsecase: ExtractGenderUsecase,
        extractMaritalStatusUsecase: ExtractMaritalStatusUsecase,
        extractJobTypeUsecase: ExtractJobTypeUsecase,
        extractNationalityTypeUsecase: ExtractNationalityTypeUsecase
    ) {
        self.repository = repository
        self.extractNIKUsecase = extractNIKUsecase
        self.extractDOBUsecase = extractDOBUsecase
        self.extractReligionTypeUsecase = extractReligionTypeUsecase
        self.extractGenderUsecase = extractGenderUsecase
        self.extractMaritalStatusUsecase = extractMaritalStatusUsecase
        self.extractJobTypeUsecase = extractJobTypeUsecase
        self.extractNationalityTypeUsecase = extractNationalityTypeUsecase
    }

    func exec(image: UIImage) async -> Result<IDModel, ExtractKTPUsecaseError> {
        do {
            var idData = IDModel()
            let data = try await repository.textRecognizer(image: image)

            // MARK: Extract Name

            if data.count > 6 {
                idData.nama = data[5].candidate.sanitize()
            }

            for text in data {
                let sanitizedText = text.candidate.sanitize()

                if let validNIK = extractNIKUsecase.exec(text: sanitizedText) {
                    idData.nik = validNIK
                }

                if let validPDOB = extractDOBUsecase.exec(text: sanitizedText) {
                    idData.pob = validPDOB.place
                    idData.dob = "\(validPDOB.day)-\(validPDOB.month)-\(validPDOB.year)".toDate(dateFormat: "dd-MM-yyyy")
                }

                if let validReligion = extractReligionTypeUsecase.exec(text: sanitizedText) {
                    idData.religion = validReligion
                }

                if let validGender = extractGenderUsecase.exec(text: sanitizedText) {
                    idData.gender = validGender
                }

                if let validMaritalStatus = extractMaritalStatusUsecase.exec(text: sanitizedText) {
                    idData.marriedStatus = validMaritalStatus
                }

                if let validJob = extractJobTypeUsecase.exec(text: sanitizedText) {
                    idData.job = validJob
                }

                if let validNationality = extractNationalityTypeUsecase.exec(text: sanitizedText) {
                    idData.nationality = validNationality
                }
            }

            return .success(idData)
        } catch {
            return .failure(.UNKNOWN)
        }
    }
}
