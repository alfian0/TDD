//
//  OCRViewAssembler.swift
//  TextValidator
//
//  Created by Alfian on 22/10/24.
//

import Swinject

@MainActor
final class OCRViewAssembler: @preconcurrency Assembly {
    func assemble(container: Swinject.Container) {
        container.register(OCRViewCoordinator.self) { _, n in
            OCRViewCoordinator(navigationController: n)
        }

        container.register(OCRViewModel.self) { r, c in
            guard let extractKTPUsecase = r.resolve(ExtractKTPUsecase.self) else {
                fatalError()
            }
            guard let nameValidationUsecase = r.resolve(NameValidationUsecase.self) else {
                fatalError()
            }
            guard let nikValidationUsecase = r.resolve(NIKValidationUsecase.self) else {
                fatalError()
            }
            guard let ageValidationUsecase = r.resolve(AgeValidationUsecase.self) else {
                fatalError()
            }
            return OCRViewModel(
                extractKTPUsecase: extractKTPUsecase,
                nameValidationUsecase: nameValidationUsecase,
                nikValidationUsecase: nikValidationUsecase,
                ageValidationUsecase: ageValidationUsecase,
                coordinator: c
            )
        }

        container.register(OCRView.self) { (r, c: OCRViewCoordinator) in
            guard let viewModel = r.resolve(OCRViewModel.self, argument: c) else {
                fatalError()
            }
            return OCRView(viewModel: viewModel)
        }
    }
}
