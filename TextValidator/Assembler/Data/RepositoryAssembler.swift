//
//  RepositoryAssembler.swift
//  TextValidator
//
//  Created by Alfian on 22/10/24.
//

import Swinject

final class RepositoryAssembler: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(VisionRepositoryImpl.self) { r in
            guard let visionService = r.resolve(VisionService.self) else {
                fatalError()
            }
            return VisionRepositoryImpl(visionService: visionService)
        }

        container.register(CountryCodeRepositoryImpl.self) { _ in
            CountryCodeRepositoryImpl()
        }

        container.register(AuthRepositoryImpl.self) { r in
            guard let firebaseAuthService = r.resolve(FirebaseAuthService.self) else {
                fatalError()
            }
            guard let biometricService = r.resolve(BiometricService.self) else {
                fatalError()
            }
            guard let networkMonitorService = r.resolve(NetworkMonitorService.self) else {
                fatalError()
            }
            return AuthRepositoryImpl(
                firebaseAuthService: firebaseAuthService,
                biometricService: biometricService,
                networkMonitorService: networkMonitorService
            )
        }
    }
}
