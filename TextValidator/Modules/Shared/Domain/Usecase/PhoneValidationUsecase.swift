//
//  PhoneValidationUsecase.swift
//  TextValidator
//
//  Created by Alfian on 03/10/24.
//

import Foundation
import Swinject

class PhoneValidationUsecaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(PhoneValidationUsecase.self) { _ in
            PhoneValidationUsecase()
        }
    }
}

final class PhoneValidationUsecase {
    func execute(input: String) -> TextValidationError? {
        guard !input.isEmpty else {
            return .EMPTY
        }

        let regex = "^\\+[1-9][0-9]{5,15}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: input) ? nil : .INVALID_FORMAT
    }
}
