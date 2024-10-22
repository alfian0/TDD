//
//  OCRViewModel.swift
//  TextValidator
//
//  Created by Alfian on 21/10/24.
//

import Combine
import SwiftUI

@MainActor
final class OCRViewModel: ObservableObject {
    @Published var isTakePicture: Bool = false
    @Published var idCardImage: UIImage? = UIImage(named: "img_id_card_placeholder")
    @Published var name: String = ""
    @Published var nameError: String?
    @Published var idNumber: String = ""
    @Published var idNumberError: String?
    @Published var dateOfBirth: Date = .init()
    @Published var dateOfBirthError: String?
    @Published var canSubmit: Bool = false

    private let extractKTPUsecase: ExtractKTPUsecase
    private let nameValidationUsecase: NameValidationUsecase
    private let nikValidationUsecase: NIKValidationUsecase
    private let ageValidationUsecase: AgeValidationUsecase
    private let coordinator: OCRViewCoordinator
    private var cancellables = Set<AnyCancellable>()

    init(
        extractKTPUsecase: ExtractKTPUsecase,
        nameValidationUsecase: NameValidationUsecase,
        nikValidationUsecase: NIKValidationUsecase,
        ageValidationUsecase: AgeValidationUsecase,
        coordinator: OCRViewCoordinator
    ) {
        self.extractKTPUsecase = extractKTPUsecase
        self.nameValidationUsecase = nameValidationUsecase
        self.nikValidationUsecase = nikValidationUsecase
        self.ageValidationUsecase = ageValidationUsecase
        self.coordinator = coordinator

        setupBindings()
    }

    private func setupBindings() {
        Publishers.CombineLatest3(
            $name.map(nameValidationUsecase.execute),
            $idNumber.map(nikValidationUsecase.execute),
            $dateOfBirth.map(ageValidationUsecase.execute)
        )
        .sink { [weak self] nameError, idNumberError, dobError in
            self?.nameError = nameError?.localizedDescription
            self?.idNumberError = idNumberError?.localizedDescription
            self?.dateOfBirthError = dobError?.localizedDescription
            self?.canSubmit = nameError == nil && idNumberError == nil && dobError == nil && !self!.name.isEmpty && !self!.idNumber.isEmpty
        }
        .store(in: &cancellables)

        $idCardImage
            .sink { [weak self] image in
                guard let self = self, let image = image else { return }
                self.extractDataFromImage(image)
            }
            .store(in: &cancellables)
    }

    private func extractDataFromImage(_ image: UIImage) {
        Task {
            let result = await extractKTPUsecase.exec(image: image)
            handleExtractionResult(result)
        }
    }

    private func handleExtractionResult(_ result: Result<IDModel, ExtractKTPUsecaseError>) {
        switch result {
        case let .success(model):
            name = model.nama ?? ""
            idNumber = model.nik ?? ""
            dateOfBirth = model.dob ?? .init()
        case let .failure(error):
            coordinator.present(.error(title: "Error", subtitle: error.localizedDescription, didDismiss: {}))
        }
    }
}
