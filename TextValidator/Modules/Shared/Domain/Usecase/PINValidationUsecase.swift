//
//  PINValidationUsecase.swift
//  TextValidator
//
//  Created by Alfian on 10/10/24.
//

import Foundation
import Swinject

class PINValidationUsecaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(PINValidationUsecase.self) { r in
            guard let service = r.resolve(SetPINService.self) else {
                fatalError()
            }
            return PINValidationUsecase(service: service)
        }
    }
}

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
            return .success(false)
        }

        if pin != repin {
            return failWithError(.NOT_EQUAL)
        }

        return service.verifyPIN(pin: pin)
            .map { true }
            .mapError { VerifyError.NETWORK_ERROR($0) }
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

    private func failWithError(_ errorType: TextValidationError) -> Result<Bool, VerifyError> {
        return .failure(.TEXT_ERROR(errorType))
    }
}
