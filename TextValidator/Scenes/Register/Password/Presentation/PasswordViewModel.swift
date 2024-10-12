//
//  PasswordViewModel.swift
//  TextValidator
//
//  Created by Alfian on 10/10/24.
//

import SwiftUI
import Combine

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

final class PasswordViewModel: ObservableObject {
	@Published var password: String = ""
	@Published var repassword: String = ""
	@Published var passwordStrength: PasswordStrength = .veryWeak
	
	private(set) var cancellables = Set<AnyCancellable>()
	
	init() {
		$password
			.sink { [weak self] value in
				guard let self = self else { return }
				
				var includesLowercaseCharacter = false,
						includesUppercaseCharacter = false,
						includesDecimalDigitCharacter = false,
						includesPunctuationCharacter = false,
						includesSymbolCharacter = false,
						includesWhitespaceCharacter = false,
						includesNonBaseCharacter = false
				
				var sizeOfCharacterSet: Float = 0
				value.enumerateSubstrings(in: value.startIndex ..< value.endIndex, options: .byComposedCharacterSequences) { substring, _, _, _ in
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
				
				let entropy = log2f(sizeOfCharacterSet) * Float(value.count)
				self.passwordStrength = self.passwordStrength(forEntropy: value.isEmpty ? 0 : entropy)
			}
			.store(in: &cancellables)
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
