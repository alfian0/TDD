//
//  OCRUsecaseAssembler.swift
//  TextValidator
//
//  Created by Alfian on 22/10/24.
//

import Swinject

final class OCRUsecaseAssembler: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(CandidateMatchingUsecase.self) { _ in
            CandidateMatchingUsecase()
        }

        container.register(ExtractKTPUsecase.self) { r in
            guard let repository = r.resolve(MachineLearningRepositoryImpl.self) else {
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

        container.register(ExtractNIKUsecase.self) { r in
            guard let nikUsecase = r.resolve(NIKValidationUsecase.self) else {
                fatalError()
            }
            return ExtractNIKUsecase(nikUsecase: nikUsecase)
        }

        container.register(ExtractDOBUsecase.self) { _ in
            ExtractDOBUsecase()
        }

        container.register(ExtractNationalityTypeUsecase.self) { _ in
            ExtractNationalityTypeUsecase()
        }

        container.register(ExtractJobTypeUsecase.self) { _ in
            ExtractJobTypeUsecase()
        }

        container.register(ExtractReligionTypeUsecase.self) { _ in
            ExtractReligionTypeUsecase()
        }

        container.register(ExtractMaritalStatusUsecase.self) { _ in
            ExtractMaritalStatusUsecase()
        }

        container.register(ExtractGenderUsecase.self) { _ in
            ExtractGenderUsecase()
        }
    }
}
