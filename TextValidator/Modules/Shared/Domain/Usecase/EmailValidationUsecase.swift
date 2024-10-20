//
//  EmailValidationUsecase.swift
//  TextValidator
//
//  Created by Alfian on 14/10/24.
//

import Foundation
import Swinject

class EmailValidationUsecaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(EmailValidationUsecase.self) { _ in
            EmailValidationUsecase()
        }
    }
}

final class EmailValidationUsecase {
    func execute(input: String) -> TextValidationError? {
        guard !input.isEmpty else {
            return .EMPTY
        }
        // Email validation regex pattern based on RFC 5322
        let regex = "^(?:[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*" +
            "|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]" +
            "|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+" +
            "[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?|" +
            "\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}" +
            "(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-zA-Z0-9-]*[a-zA-Z0-9]:" +
            "(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]" +
            "|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: input) ? nil : .INVALID_FORMAT
    }
}
