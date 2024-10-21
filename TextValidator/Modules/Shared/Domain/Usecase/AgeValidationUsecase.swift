//
//  AgeValidationUsecase.swift
//  TextValidator
//
//  Created by Alfian on 21/10/24.
//

import Foundation

final class AgeValidationUsecase {
    func execute(input: Date) -> TextValidationError? {
        return isValidAge(dob: input) ? nil : .AGE_LIMIT
    }

    func isValidAge(dob: Date) -> Bool {
        let calendar = Calendar.current
        let currentDate = Date()

        // Calculate age by getting the difference in years
        let ageComponents = calendar.dateComponents([.year], from: dob, to: currentDate)
        let age = ageComponents.year ?? 0

        // Check if age is between 17 and 90
        return age >= 17 && age <= 90
    }
}
