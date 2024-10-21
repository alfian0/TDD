//
//  ExtractDOBUsecase.swift
//  TextValidator
//
//  Created by Alfian on 19/10/24.
//

import Foundation

final class ExtractDOBUsecase {
    func exec(text: String) -> (place: String, day: String, month: String, year: String)? {
        let pattern = "([A-Za-z]+)[\\.,\\s-]?\\s?(\\d{2})[\\.,\\s-](\\d{2})[\\.,\\s-](\\d{4})"

        do {
            let regex = try NSRegularExpression(pattern: pattern)
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
