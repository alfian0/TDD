//
//  TextValidationUsecase.swift
//  TextValidator
//
//  Created by Alfian on 22/10/24.
//

import Swinject

final class TextValidationUsecase: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(AgeValidationUsecase.self) { _ in
            AgeValidationUsecase()
        }

        container.register(NIKValidationUsecase.self) { _ in
            NIKValidationUsecase()
        }

        container.register(NameValidationUsecase.self) { _ in
            NameValidationUsecase()
        }

        container.register(PINValidationUsecase.self) { r in
            guard let service = r.resolve(SetPINService.self) else {
                fatalError()
            }
            return PINValidationUsecase(service: service)
        }

        container.register(EmailValidationUsecase.self) { _ in
            EmailValidationUsecase()
        }

        container.register(PhoneValidationUsecase.self) { _ in
            PhoneValidationUsecase()
        }
    }
}
