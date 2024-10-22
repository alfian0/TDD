//
//  CandidateMatchingUsecase.swift
//  TextValidator
//
//  Created by Alfian on 22/10/24.
//

final class CandidateMatchingUsecase {
    func exec(_ texts: [String]) -> Bool {
        var matchCount = 0

        for text in texts {
            for keyword in keywords {
                if levenshteinDistance(text, keyword) < 3 {
                    matchCount += 1
                    if matchCount >= 3 {
                        return true // Early exit when 3 matches found
                    }
                    break // Avoid checking other keywords once a match is found
                }
            }
        }

        return false // Return false if fewer than 3 matches
    }
}
