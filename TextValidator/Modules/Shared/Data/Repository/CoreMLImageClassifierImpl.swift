//
//  CoreMLImageClassifierImpl.swift
//  TextValidator
//
//  Created by Alfian on 29/10/24.
//

import CoreML
import UIKit

class CoreMLImageClassifierImpl: ImageClassifierRepository {
    private let visionService: VisionService

    init(visionService: VisionService) {
        self.visionService = visionService
    }

    func classifyKTP(image: UIImage) async throws -> ClassificationResult? {
        let configuration = MLModelConfiguration()
        #if targetEnvironment(simulator)
            configuration.computeUnits = .cpuOnly
        #endif
        let coreMLModel = try KTP(configuration: configuration)
        let result = try await visionService.classify(image: image, mlmodel: coreMLModel.model)
        let maxResult = result.max(by: { $0.confidence < $1.confidence })
        return maxResult.map { ClassificationResult(identifier: $0.identifier, confidence: $0.confidence) }
    }
}
