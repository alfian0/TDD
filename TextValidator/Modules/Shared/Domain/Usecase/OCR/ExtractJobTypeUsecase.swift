//
//  ExtractJobTypeUsecase.swift
//  TextValidator
//
//  Created by Alfian on 19/10/24.
//

final class ExtractJobTypeUsecase {
    func exec(text: String) -> JobType? {
        JobType.allCases.first { $0.rawValue.hasPrefix(text.uppercased()) }
    }
}
