//
//  RepositoryAssembler.swift
//  TextValidator
//
//  Created by Alfian on 22/10/24.
//

import Swinject

final class RepositoryAssembler: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(MachineLearningRepositoryImpl.self) { r in
            guard let visionService = r.resolve(VisionService.self) else {
                fatalError()
            }
            return MachineLearningRepositoryImpl(visionService: visionService)
        }

        container.register(CountryCodeRepositoryImpl.self) { _ in
            CountryCodeRepositoryImpl()
        }

        container.register(AuthRepositoryImpl.self) { r in
            guard let firebaseAuthService = r.resolve(FirebaseAuthService.self) else {
                fatalError()
            }
            return AuthRepositoryImpl(
                firebaseAuthService: firebaseAuthService
            )
        }
    }
}
