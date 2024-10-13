//
//  DataError.swift
//  TextValidator
//
//  Created by Alfian on 03/10/24.
//

enum DataError {
    enum Network: Error {
        case REQUEST_TIMEOUT
        case NO_INTERNET
        case NOT_FOUND
    }

    enum Local: Error {
        case NOT_FOUND
    }
}
