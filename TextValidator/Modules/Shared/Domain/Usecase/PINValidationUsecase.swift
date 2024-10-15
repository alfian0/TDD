//
//  PINValidationUsecase.swift
//  TextValidator
//
//  Created by Alfian on 10/10/24.
//

import Combine
import Foundation

enum VerifyError: Error {
    case TEXT_ERROR(TextValidationError)
    case NETWORK_ERROR(Error)
}

final class PINValidationUsecase {
    private let service: PINRepository

    init(service: PINRepository) {
        self.service = service
    }

    func execute(pin: String, repin: String) -> AnyPublisher<Bool, VerifyError> {
        if pin.isEmpty {
            return failWithError(.EMPTY)
        }

        // MARK: ISO 9564-1

        if pin.count < 4 {
            return failWithError(.TOO_SHORT)
        }

        // MARK: ISO 9564-1

        if pin.count > 12 {
            return failWithError(.TOO_LONG)
        }

        if hasIdenticalConsecutiveCharacters(in: pin) {
            return failWithError(.IDENTICAL_CONSECUTIVE)
        }

        if isSequentialOrReverse(pin) {
            return failWithError(.CANNOT_SQUENTIAL)
        }

        if repin.isEmpty {
            return Just(false)
                .setFailureType(to: VerifyError.self)
                .eraseToAnyPublisher()
        }

        if pin != repin {
            return failWithError(.NOT_EQUAL)
        }

        return service.verifyPIN(pin: pin)
            .map { true }
            .catch { error in
                Fail(error: VerifyError.NETWORK_ERROR(error))
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    // Helper methods

    private func hasIdenticalConsecutiveCharacters(in pin: String) -> Bool {
        return Set(Array(pin)).count == 1
    }

    private func isSequentialOrReverse(_ pin: String) -> Bool {
        guard let firstDigit = pin.first.flatMap({ Int(String($0)) }) else { return false }

        let sequential: [Int] = Array(firstDigit ..< firstDigit + pin.count)
        let reverseSequential: [Int] = Array((firstDigit - pin.count + 1) ... firstDigit).reversed()

        let inputArray = pin.compactMap { Int(String($0)) }
        return inputArray == sequential || inputArray == reverseSequential
    }

    private func failWithError(_ errorType: TextValidationError) -> AnyPublisher<Bool, VerifyError> {
        return Fail(error: VerifyError.TEXT_ERROR(errorType))
            .eraseToAnyPublisher()
    }
}
