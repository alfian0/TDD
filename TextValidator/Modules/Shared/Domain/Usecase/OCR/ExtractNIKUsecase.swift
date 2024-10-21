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

    func exec(text: String) -> String? {
        let texts = text.components(separatedBy: " ")
        return texts.compactMap { text in
            guard text.regex(with: "^[A-Za-z0-9]{16}+$") else { return nil }
            var processedNIK = text
            for i in 0 ..< NIKWordDic.count {
                guard let dict = NIKWordDic[i].first else { continue }
                processedNIK = text.replacingOccurrences(of: dict.key, with: dict.value)
            }

            return nikUsecase.execute(input: processedNIK) == nil ? processedNIK : nil
        }.first
    }
}
