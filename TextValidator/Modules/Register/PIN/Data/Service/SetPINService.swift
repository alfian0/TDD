//
//  SetPINService.swift
//  TextValidator
//
//  Created by Alfian on 10/10/24.
//

import Foundation

final class SetPINService {
    func verifyPIN(pin: String) -> Result<Void, any Error> {
        if pin == "261092" {
            return .failure(NSError(domain: "pin.data.service", code: 0))
        } else {
            return .success(())
        }
    }
}
