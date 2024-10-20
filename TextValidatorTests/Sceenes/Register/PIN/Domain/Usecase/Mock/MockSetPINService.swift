//
//  MockSetPINService.swift
//  TextValidator
//
//  Created by Alfian on 12/10/24.
//

import Combine
import Foundation
@testable import TextValidator

// final class MockSetPINService: PINRepository {
//    var error: NSError?
//
//    func verifyPIN(pin _: String) -> AnyPublisher<Void, any Error> {
//        guard let error = error else {
//            return Just(())
//                .setFailureType(to: Error.self)
//                .eraseToAnyPublisher()
//        }
//        return Fail(error: error)
//            .eraseToAnyPublisher()
//    }
// }
