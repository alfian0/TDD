//
//  RepositoryAssembler.swift
//  TextValidator
//
//  Created by Alfian on 22/10/24.
//

import Swinject

final class RepositoryAssembler: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(CameraCaptureRepository.self) { _ in
            UIKitCameraCaptureRepositoryImpl()
//            VisionCameraCaptureRepositoryImpl()
//            AVKitCameraCaptureRepositoryImpl()
        }
        .inObjectScope(.container)

        container.register(CountryCodeRepositoryImpl.self) { _ in
            CountryCodeRepositoryImpl()
        }
        .inObjectScope(.container)

        container.register(AuthRepositoryImpl.self) { r in
            guard let firebaseAuthService = r.resolve(FirebaseAuthService.self) else {
                fatalError()
            }
            return AuthRepositoryImpl(
                firebaseAuthService: firebaseAuthService
            )
        }
        .inObjectScope(.container)
    }
}
