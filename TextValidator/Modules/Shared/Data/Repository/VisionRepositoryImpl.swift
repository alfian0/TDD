//
//  VisionRepositoryImpl.swift
//  TextValidator
//
//  Created by Alfian on 20/10/24.
//

import Swinject
import UIKit

class VisionRepositoryImplAssembly: Assembly {
    func assemble(container: Container) {
        container.register(VisionRepositoryImpl.self) { r in
            guard let visionService = r.resolve(VisionService.self) else {
                fatalError()
            }
            return VisionRepositoryImpl(visionService: visionService)
        }
    }
}

final class VisionRepositoryImpl {
    private let visionService: VisionService

    init(visionService: VisionService) {
        self.visionService = visionService
    }

    func textRecognizer(image: UIImage) async throws -> [TextRecognizerModel] {
        try await visionService.textRecognizer(image: image)
            .compactMap { VNRecognizedTextObservationMapper.map(model: $0) }
    }
}
