//
//  ExtractJobTypeUsecase.swift
//  TextValidator
//
//  Created by Alfian on 19/10/24.
//

final class ExtractJobTypeUsecase {
    func exec(text: String) -> JobType? {
        return JobType.allCases.first { text.contains($0.rawValue) }
    }
}
