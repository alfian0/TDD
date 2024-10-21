//
//  OCRViewModel.swift
//  TextValidator
//
//  Created by Alfian on 21/10/24.
//

import Combine
import SwiftUI
import Swinject

@MainActor
class OCRViewModelAssembly: @preconcurrency Assembly {
    func assemble(container: Container) {
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
    }
}

@MainActor
final class OCRViewModel: ObservableObject {
    @Published var isTakePicture: Bool = false
    @Published var idImage: UIImage? = UIImage(named: "img_id_card_placeholder")
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

        $name
            .removeDuplicates()
            .map(nameValidationUsecase.execute)
            .map { $0?.localizedDescription }
            .assign(to: &$nameError)

        $idNumber
            .removeDuplicates()
            .map(nikValidationUsecase.execute)
            .map { $0?.localizedDescription }
            .assign(to: &$idNumberError)

        $dateOfBirth
            .removeDuplicates()
            .map(ageValidationUsecase.execute)
            .map { $0?.localizedDescription }
            .assign(to: &$dateOfBirthError)

        $idImage
            .sink { [weak self] image in
                guard let self = self else { return }
                guard let image = image else { return }
                Task {
                    let result = await extractKTPUsecase.exec(image: image)
                    guard case let .success(model) = result else {
                        if case let .failure(error) = result {
                            coordinator.present(.error(title: "Error", subtitle: error.localizedDescription, didDismiss: {}))
                        }
                        return
                    }
                    if let extractedName = model.nama {
                        self.name = extractedName
                    }
                    if let extractedNIK = model.nik {
                        self.idNumber = extractedNIK
                    }
                    if let extractedDOB = model.dob {
                        self.dateOfBirth = extractedDOB
                    }
                }
            }
            .store(in: &cancellables)

        Publishers.CombineLatest3($nameError, $idNumberError, $dateOfBirthError)
            .map { [weak self] nameError, idNumberError, dateOfBirthError in
                guard let self = self else { return false }
                return nameError == nil && idNumberError == nil && dateOfBirthError == nil && !name.isEmpty && !idNumber.isEmpty
            }
            .assign(to: \.canSubmit, on: self)
            .store(in: &cancellables)
    }
}
