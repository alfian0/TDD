//
//  PasswordStrengthUsecase.swift
//  TextValidator
//
//  Created by Alfian on 12/10/24.
//

import Foundation
import SwiftUI
import Swinject

class PasswordStrengthUsecaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(PasswordStrengthUsecase.self) { _ in
            PasswordStrengthUsecase()
        }
    }
}

enum PasswordStrength: Int, CaseIterable {
    case veryWeak
    case weak
    case reasonable
    case strong
    case veryStrong

    var color: Color {
        switch self {
        case .veryWeak:
            return .red
        case .weak:
            return .orange
        case .reasonable:
            return .yellow
        case .strong:
            return .blue
        case .veryStrong:
            return .green
        }
    }
}

final class PasswordStrengthUsecase {
    func execute(password: String) -> Result<PasswordStrength, TextValidationError> {
        guard password.count >= 8 else {
            return .failure(.TOO_SHORT)
        }

        var includesLowercaseCharacter = false,
            includesUppercaseCharacter = false,
            includesDecimalDigitCharacter = false,
            includesPunctuationCharacter = false,
            includesSymbolCharacter = false,
            includesWhitespaceCharacter = false,
            includesNonBaseCharacter = false

        var sizeOfCharacterSet: Float = 0
        password.enumerateSubstrings(in: password.startIndex ..< password.endIndex, options: .byComposedCharacterSequences) { substring, _, _, _ in
            guard let unicodeScalars = substring?.first?.unicodeScalars.first else {
                return
            }

            if !includesLowercaseCharacter && CharacterSet.lowercaseLetters.contains(unicodeScalars) {
                includesLowercaseCharacter = true
                sizeOfCharacterSet += 26
            }

            if !includesUppercaseCharacter && CharacterSet.uppercaseLetters.contains(unicodeScalars) {
                includesUppercaseCharacter = true
                sizeOfCharacterSet += 26
            }

            if !includesDecimalDigitCharacter && CharacterSet.decimalDigits.contains(unicodeScalars) {
                includesDecimalDigitCharacter = true
                sizeOfCharacterSet += 10
            }

            if !includesSymbolCharacter && CharacterSet.symbols.contains(unicodeScalars) {
                includesSymbolCharacter = true
                sizeOfCharacterSet += 10
            }

            if !includesPunctuationCharacter && CharacterSet.punctuationCharacters.contains(unicodeScalars) {
                includesPunctuationCharacter = true
                sizeOfCharacterSet += 20
            }

            if !includesWhitespaceCharacter && CharacterSet.whitespacesAndNewlines.contains(unicodeScalars) {
                includesWhitespaceCharacter = true
                sizeOfCharacterSet += 1
            }

            if !includesNonBaseCharacter && CharacterSet.nonBaseCharacters.contains(unicodeScalars) {
                includesNonBaseCharacter = true
                sizeOfCharacterSet += 32 + 128
            }
        }

        let entropy = log2f(sizeOfCharacterSet) * Float(password.count)
        return .success(passwordStrength(forEntropy: entropy))
    }

    private func passwordStrength(forEntropy entropy: Float) -> PasswordStrength {
        if entropy < 28 {
            return .veryWeak
        } else if entropy < 36 {
            return .weak
        } else if entropy < 60 {
            return .reasonable
        } else if entropy < 128 {
            return .strong
        } else {
            return .veryStrong
        }
    }
}
