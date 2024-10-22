//
//  ServiceAssembler.swift
//  TextValidator
//
//  Created by Alfian on 22/10/24.
//

import Swinject

final class ServiceAssembler: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(VisionService.self) { _ in
            VisionService()
        }

        container.register(UserdefaultsService.self) { _ in
            UserdefaultsService()
        }

        container.register(BiometricService.self) { _ in
            BiometricService()
        }

        container.register(KeychainService.self) { _ in
            KeychainService()
        }

        container.register(FirebaseAuthService.self) { _ in
            FirebaseAuthService()
        }

        container.register(CameraService.self) { _ in
            CameraService()
        }
    }
}
