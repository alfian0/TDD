//
//  ExtractNIKUsecase.swift
//  TextValidator
//
//  Created by Alfian on 19/10/24.
//

import Foundation
import Swinject

class ExtractNIKUsecaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ExtractNIKUsecase.self) { r in
            guard let nikUsecase = r.resolve(NIKValidationUsecase.self) else {
                fatalError()
            }
            return ExtractNIKUsecase(nikUsecase: nikUsecase)
        }
    }
}

final class ExtractNIKUsecase {
    private let nikUsecase: NIKValidationUsecase

    init(nikUsecase: NIKValidationUsecase) {
        self.nikUsecase = nikUsecase
    }

    func exec(texts: [String]) -> String? {
        let allWords = texts
            .map { $0.components(separatedBy: " ") }
            .flatMap { $0 }

        // Loop through each word and check regex
        for word in allWords {
            guard word.regex(with: "^[A-Za-z0-9]{16}+$") else { continue }

            var processedNIK = word

            // Replace any keywords in NIKWordDic
            for dict in NIKWordDic {
                if let key = dict.keys.first, let value = dict[key] {
                    processedNIK = processedNIK.replacingOccurrences(of: key, with: value)
                }
            }

            // Return the first valid NIK (when nikUsecase validation passes)
            if nikUsecase.execute(input: processedNIK) == nil {
                return processedNIK
            }
        }

        // Return nil if no valid NIK is found
        return nil
    }
}
