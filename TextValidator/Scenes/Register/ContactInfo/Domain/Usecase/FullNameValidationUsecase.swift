//
//  FullNameValidationUsecase.swift
//  TextValidator
//
//  Created by Alfian on 03/10/24.
//

final class FullNameValidationUsecase {
    func execute(input: String) -> TextValidationError? {
        guard !input.isEmpty else {
            return .EMPTY
        }

        guard input.count > 3 else {
            return .TOO_SHORT
        }

        guard input.count <= 20 else {
            return .TOO_LONG
        }

        return nil
    }
}
