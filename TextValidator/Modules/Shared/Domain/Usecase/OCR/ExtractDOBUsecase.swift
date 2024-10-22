//
//  ExtractDOBUsecase.swift
//  TextValidator
//
//  Created by Alfian on 19/10/24.
//

import Foundation

final class ExtractDOBUsecase {
    func exec(texts: [String]) -> (place: String, day: String, month: String, year: String)? {
        for text in texts {
            if let result = exect(text: text) {
                return result
            }
        }
        return nil
    }

    private func exect(text: String) -> (place: String, day: String, month: String, year: String)? {
        do {
            let regex = try NSRegularExpression(pattern: OCRRegex.dob)
            let nsString = text as NSString
            let matches = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))

            if let match = matches.first {
                let place = nsString.substring(with: match.range(at: 1))
                let day = nsString.substring(with: match.range(at: 2))
                let month = nsString.substring(with: match.range(at: 3))
                let year = nsString.substring(with: match.range(at: 4))

                return (place, day, month, year)
            }
        } catch {
            print("Invalid regex: \(error.localizedDescription)")
        }

        return nil
    }
}
