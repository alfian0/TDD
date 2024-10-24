//
//  PINValidationUsecase.swift
//  TextValidator
//
//  Created by Alfian on 10/10/24.
//

import Foundation

enum VerifyError: Error {
    case TEXT_ERROR(TextValidationError)
    case NETWORK_ERROR(Error)
}

final class PINValidationUsecase {
    private let service: SetPINService

    init(service: SetPINService) {
        self.service = service
    }

    func execute(pin: String, repin: String) -> Result<Bool, VerifyError> {
        if let error = ValidationHelper.validateEmpty(pin) {
            return failWithError(error)
        }

        if let lengthError = ValidationHelper.validateLength(pin, min: 4, max: 12) {
            return failWithError(lengthError)
        }

        if hasIdenticalConsecutiveCharacters(in: pin) {
            return failWithError(.identicalConsecutive)
        }

        if isSequentialOrReverse(pin) {
            return failWithError(.cannotSequential)
        }

        guard !repin.isEmpty else {
            return .success(false)
        }

        if pin != repin {
            return failWithError(.notEqual)
        }

        return service.verifyPIN(pin: pin)
            .map { true }
            .mapError { VerifyError.NETWORK_ERROR($0) }
    }

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

    private func failWithError(_ errorType: TextValidationError) -> Result<Bool, VerifyError> {
        return .failure(.TEXT_ERROR(errorType))
    }
}
