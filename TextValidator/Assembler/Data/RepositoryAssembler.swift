//
//  RepositoryAssembler.swift
//  TextValidator
//
//  Created by Alfian on 22/10/24.
//

import Swinject

final class RepositoryAssembler: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(VisionOCRRepositoryImpl.self) { r in
            guard let visionService = r.resolve(VisionService.self) else {
                fatalError()
            }
            return VisionOCRRepositoryImpl(visionService: visionService)
        }

        container.register(DocumentScannerRepository.self) { _ in
            VisionDocumentScannerRepositoryImpl()
        }

        container.register(ImageClassifierRepository.self) { r in
            guard let visionService = r.resolve(VisionService.self) else {
                fatalError()
            }
            return CoreMLImageClassifierImpl(visionService: visionService)
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
