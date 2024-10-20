//
//  ExtractNIKUsecase.swift
//  TextValidator
//
//  Created by Alfian on 19/10/24.
//

import Foundation

final class ExtractNIKUsecase {
    func exec(text: String) -> String? {
        let texts = text.components(separatedBy: " ")
        return texts.compactMap { text in
            guard text.regex(with: "^[A-Za-z0-9]{16}+$") else { return nil }
            var processedNIK = text
            for i in 0 ..< NIKWordDic.count {
                guard let dict = NIKWordDic[i].first else { continue }
                processedNIK = text.replacingOccurrences(of: dict.key, with: dict.value)
            }
            guard processedNIK.regex(with: "^((1[1-9])|(21)|([37][1-6])|(5[1-4])|(6[1-5])|([8-9][1-2]))[0-9]{2}[0-9]{2}(([0-6][0-9])|(7[0-1]))((0[1-9])|(1[0-2]))([0-9]{2})[0-9]{4}$") else {
                return nil
            }
            return processedNIK
        }.first
    }
}
