//
//  Publisher+Extension.swift
//  TextValidator
//
//  Created by Alfian on 03/10/24.
//

import Combine

public extension Publisher {
	func sink(result: @escaping ((Result<Self.Output, Self.Failure>) -> Void)) -> AnyCancellable {
		return sink { completion in
			switch completion {
				case let .failure(error):
					result(.failure(error))
				case .finished:
					break
			}
		} receiveValue: { output in
			result(.success(output))
		}
	}
}
