//
//  ExtractJobTypeUsecase.swift
//  TextValidator
//
//  Created by Alfian on 19/10/24.
//

final class ExtractJobTypeUsecase {
    func exec(text: String) -> JobType? {
        let texts = text.components(separatedBy: ":")
        return texts.compactMap { text in
            JobType.allCases.first { $0.rawValue.hasPrefix(text.uppercased()) }
        }.first
    }
}
