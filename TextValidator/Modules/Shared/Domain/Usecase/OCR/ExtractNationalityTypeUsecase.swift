//
//  ExtractNationalityTypeUsecase.swift
//  TextValidator
//
//  Created by Alfian on 19/10/24.
//

final class ExtractNationalityTypeUsecase {
    func exec(texts: [String]) -> NationalityType? {
        let texts = texts.filter { $0.regex(with: OCRRegex.alphabetical) }
        return NationalityType.allCases.min { jobType1, jobType2 in
            let minDistance1 = texts.map { levenshteinDistance($0, jobType1.rawValue) }.min() ?? Int.max
            let minDistance2 = texts.map { levenshteinDistance($0, jobType2.rawValue) }.min() ?? Int.max
            return minDistance1 < minDistance2
        }
    }
}
