//
//  VNRecognizedTextObservationMapper.swift
//  TextValidator
//
//  Created by Alfian on 20/10/24.
//

import Vision

enum VNRecognizedTextObservationMapper {
    static func map(model: VNRecognizedTextObservation) -> TextRecognizerModel? {
        guard let candidate = model.topCandidates(1).first else {
            return nil
        }
        return TextRecognizerModel(
            boundingBox: model.boundingBox,
            topLeft: model.topLeft,
            topRight: model.topRight,
            bottomLeft: model.bottomLeft,
            bottomRight: model.bottomRight,
            candidate: candidate.string,
            confidence: candidate.confidence
        )
    }
}
