//
//  ExtractNameUsecase.swift
//  TextValidator
//
//  Created by Alfian on 31/10/24.
//

final class ExtractNameUsecase {
    func exec(texts: [String]) -> String? {
        let result = texts.enumerated()
            .map { (levenshteinDistance($0.element, KTPKeywords.name), $0.offset) }
            .max { a, b in
                a.0 > b.0
            }
        guard let result = result else {
            return nil
        }
        let nameIndex = result.1 + 1
        if nameIndex < texts.count {
            return texts[nameIndex]
        }
        return nil
    }
}
