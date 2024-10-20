//
//  ExtractKTPUsecase.swift
//  TextValidator
//
//  Created by Alfian on 20/10/24.
//

import UIKit

enum ExtractKTPUsecaseError: Error, LocalizedError {
    case UNKNOWN
}

final class ExtractKTPUsecase {
    private let repository: VisionRepositoryImpl

    init(repository: VisionRepositoryImpl) {
        self.repository = repository
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

                if let validNIK = ExtractNIKUsecase().exec(text: sanitizedText) {
                    idData.nik = validNIK
                }

                if let validPDOB = ExtractDOBUsecase().exec(text: sanitizedText) {
                    idData.pob = validPDOB.place
                    idData.dob = "\(validPDOB.day)-\(validPDOB.month)-\(validPDOB.year)".toDate(dateFormat: "dd-MM-yyyy")
                }

                if let validReligion = ExtractReligionTypeUsecase().exec(text: sanitizedText) {
                    idData.religion = validReligion
                }

                if let validGender = ExtractGenderUsecase().exec(text: sanitizedText) {
                    idData.gender = validGender
                }

                if let validMaritalStatus = ExtractMaritalStatusUsecase().exec(text: sanitizedText) {
                    idData.marriedStatus = validMaritalStatus
                }

                if let validJob = ExtractJobTypeUsecase().exec(text: sanitizedText) {
                    idData.job = validJob
                }

                if let validNationality = ExtractNationalityTypeUsecase().exec(text: sanitizedText) {
                    idData.nationality = validNationality
                }
            }

            return .success(idData)
        } catch {
            return .failure(.UNKNOWN)
        }
    }
}
