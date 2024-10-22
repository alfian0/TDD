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
            guard let candidateMatchingUsecase = r.resolve(CandidateMatchingUsecase.self) else {
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
                extractNationalityTypeUsecase: extractNationalityTypeUsecase,
                candidateMatchingUsecase: candidateMatchingUsecase
            )
        }
    }
}

enum ExtractKTPUsecaseError: Error, LocalizedError {
    case NOT_VALID_KTP
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
    private let candidateMatchingUsecase: CandidateMatchingUsecase

    init(
        repository: VisionRepositoryImpl,
        extractNIKUsecase: ExtractNIKUsecase,
        extractDOBUsecase: ExtractDOBUsecase,
        extractReligionTypeUsecase: ExtractReligionTypeUsecase,
        extractGenderUsecase: ExtractGenderUsecase,
        extractMaritalStatusUsecase: ExtractMaritalStatusUsecase,
        extractJobTypeUsecase: ExtractJobTypeUsecase,
        extractNationalityTypeUsecase: ExtractNationalityTypeUsecase,
        candidateMatchingUsecase: CandidateMatchingUsecase
    ) {
        self.repository = repository
        self.extractNIKUsecase = extractNIKUsecase
        self.extractDOBUsecase = extractDOBUsecase
        self.extractReligionTypeUsecase = extractReligionTypeUsecase
        self.extractGenderUsecase = extractGenderUsecase
        self.extractMaritalStatusUsecase = extractMaritalStatusUsecase
        self.extractJobTypeUsecase = extractJobTypeUsecase
        self.extractNationalityTypeUsecase = extractNationalityTypeUsecase
        self.candidateMatchingUsecase = candidateMatchingUsecase
    }

    func exec(image: UIImage) async -> Result<IDModel, ExtractKTPUsecaseError> {
        do {
            var idData = IDModel()
            let data = try await repository.textRecognizer(image: image)
            var texts = sanitizeTexts(data.map { $0.candidate })

            guard candidateMatchingUsecase.exec(texts) else {
                return .failure(.NOT_VALID_KTP)
            }

            texts = removeKeywords(from: texts)

            idData.nama = extractName(from: data)

            extractUseCases(texts: texts, into: &idData)

            return .success(idData)
        } catch {
            return .failure(.UNKNOWN)
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
            idData.dob = "\(validPDOB.day)-\(validPDOB.month)-\(validPDOB.year)".toDate(dateFormat: "dd-MM-yyyy")
        }
    }
}
