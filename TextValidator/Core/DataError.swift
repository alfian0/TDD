//
//  DataError.swift
//  TextValidator
//
//  Created by Alfian on 03/10/24.
//

struct DataError {
	enum Network: Error {
		case REQUEST_TIMEOUT
		case NO_INTERNET
		case NOT_FOUND
	}
	
	enum Local: Error {
		case NOT_FOUND
	}
}
