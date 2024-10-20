//
//  VisionRepositoryImpl.swift
//  TextValidator
//
//  Created by Alfian on 20/10/24.
//

import UIKit

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
