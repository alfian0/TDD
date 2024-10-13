//
//  Data+Extension.swift
//  TextValidator
//
//  Created by Alfian on 01/10/24.
//

import Foundation

public extension Data {
    static func fromJSONFile(_ name: String) throws -> Data {
        guard let path = Bundle.main.path(forResource: name, ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path))
        else {
            throw NSError(domain: "fromJSONFile", code: 404)
        }

        return data
    }
}

public extension Data {
    func toCodable<T: Codable>(with type: T.Type) throws -> T {
        let decoder = JSONDecoder.default
        guard let decoded = try? decoder.decode(type.self, from: self) else {
            throw NSError(domain: "toCodable", code: 404)
        }
        return decoded
    }
}

public extension Data {
    func toString() throws -> String {
        guard let jsonString = String(data: self, encoding: .utf8) else {
            throw NSError(domain: "toString", code: 404)
        }
        return jsonString
            .replacingOccurrences(of: "\\s+", with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
