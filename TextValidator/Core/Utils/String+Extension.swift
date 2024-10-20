//
//  String+Extension.swift
//  TextValidator
//
//  Created by Alfian on 06/10/24.
//

import Foundation

extension String {
    func getRangeOf(_ string: String) -> NSRange? {
        let range = self.range(of: string)
        if let range = range {
            return NSRange(range, in: self)
        }
        return nil
    }
}

extension String {
    func toDate(dateFormat format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ID")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.date(from: self)
    }
}

extension String {
    func regex(with pattern: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }
}

extension String {
    func sanitize() -> String {
        replacingOccurrences(of: ":", with: " ")
            .replacingOccurrences(of: ".", with: " ")
            .replacingOccurrences(of: ",", with: "")
            .trimmingCharacters(in: .whitespaces)
    }
}
