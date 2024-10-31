//
//  ExtractKTPUsecase.swift
//  TextValidator
//
//  Created by Alfian on 20/10/24.
//

import UIKit

enum ExtractKTPUsecaseError: Error, LocalizedError {
    case invalidKTP
    case unknown
}

final class ExtractKTPUsecase {
    private let ocrKTPUsecase: OCRKTPUsecase
    private let cropKTPUseCase: CropKTPUseCase
    private let documentScannerRepository: DocumentScannerRepository
    private let classifiedKTPUsecase: ClassifiedKTPUsecase
    private let extractNIKUsecase: ExtractNIKUsecase
    private let extractDOBUsecase: ExtractDOBUsecase
    private let extractReligionTypeUsecase: ExtractReligionTypeUsecase
    private let extractGenderUsecase: ExtractGenderUsecase
    private let extractMaritalStatusUsecase: ExtractMaritalStatusUsecase
    private let extractJobTypeUsecase: ExtractJobTypeUsecase
    private let extractNationalityTypeUsecase: ExtractNationalityTypeUsecase
    private let candidateMatchingUsecase: CandidateMatchingUsecase

    init(
        documentScannerRepository: DocumentScannerRepository,
        ocrKTPUsecase: OCRKTPUsecase,
        cropKTPUseCase: CropKTPUseCase,
        classifiedKTPUsecase: ClassifiedKTPUsecase,
        extractNIKUsecase: ExtractNIKUsecase,
        extractDOBUsecase: ExtractDOBUsecase,
        extractReligionTypeUsecase: ExtractReligionTypeUsecase,
        extractGenderUsecase: ExtractGenderUsecase,
        extractMaritalStatusUsecase: ExtractMaritalStatusUsecase,
        extractJobTypeUsecase: ExtractJobTypeUsecase,
        extractNationalityTypeUsecase: ExtractNationalityTypeUsecase,
        candidateMatchingUsecase: CandidateMatchingUsecase
    ) {
        self.ocrKTPUsecase = ocrKTPUsecase
        self.cropKTPUseCase = cropKTPUseCase
        self.documentScannerRepository = documentScannerRepository
        self.classifiedKTPUsecase = classifiedKTPUsecase
        self.extractNIKUsecase = extractNIKUsecase
        self.extractDOBUsecase = extractDOBUsecase
        self.extractReligionTypeUsecase = extractReligionTypeUsecase
        self.extractGenderUsecase = extractGenderUsecase
        self.extractMaritalStatusUsecase = extractMaritalStatusUsecase
        self.extractJobTypeUsecase = extractJobTypeUsecase
        self.extractNationalityTypeUsecase = extractNationalityTypeUsecase
        self.candidateMatchingUsecase = candidateMatchingUsecase
    }

    func exec() async -> Result<IDModel, ExtractKTPUsecaseError> {
        do {
            var idData = IDModel()
            let image = try await documentScannerRepository.scanDocument()
            let valid = try await classifiedKTPUsecase.exec(image: image)

            guard let valid = valid?.identifier, valid == "valid" else {
                return .failure(.invalidKTP)
            }

            let croppedImageIfCan = try await cropKTPUseCase.exec(image: image)

            let data = try await ocrKTPUsecase.textRecognizer(image: croppedImageIfCan)
            var texts = sanitizeTexts(data.map { $0.candidate })

            guard candidateMatchingUsecase.exec(texts) else {
                return .failure(.invalidKTP)
            }

            texts = removeKeywords(from: texts)

            idData.image = image
            idData.nama = extractName(from: data)

            extractUseCases(texts: texts, into: &idData)

            return .success(idData)
        } catch {
            return .failure(.unknown)
        }
    }

    // MARK: - Helper Functions

    private func sanitizeTexts(_ texts: [String]) -> [String] {
        return texts.map { $0.sanitize() }
    }

    private func removeKeywords(from texts: [String]) -> [String] {
        return texts.map { text in
            var newText = text
            for keyword in keywords {
                newText = newText.replacingOccurrences(of: keyword, with: "")
            }
            return newText
        }
    }

    private func extractName(from data: [TextRecognizerModel]) -> String? {
        guard data.count > 6 else { return nil }
        return data[5].candidate.sanitize()
    }

    private func extractUseCases(texts: [String], into idData: inout IDModel) {
        idData.nik = extractNIKUsecase.exec(texts: texts)
        idData.religion = extractReligionTypeUsecase.exec(texts: texts)
        idData.gender = extractGenderUsecase.exec(texts: texts)
        idData.marriedStatus = extractMaritalStatusUsecase.exec(texts: texts)
        idData.job = extractJobTypeUsecase.exec(texts: texts)
        idData.nationality = extractNationalityTypeUsecase.exec(texts: texts)

        if let validPDOB = extractDOBUsecase.exec(texts: texts) {
            idData.pob = validPDOB.place
            idData.dob = "\(validPDOB.day)-\(validPDOB.month)-\(validPDOB.year)".toDate(dateFormat: OCRDateFormat.ktp)
        }
    }
}
