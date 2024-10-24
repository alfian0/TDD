//
//  NetworkError.swift
//  TextValidator
//
//  Created by Alfian on 24/10/24.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case offline

    var errorDescription: String? {
        switch self {
        case .offline:
            return "No Internet Connection"
        }
    }
}
