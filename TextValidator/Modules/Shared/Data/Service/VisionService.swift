//
//  VisionService.swift
//  TextValidator
//
//  Created by Alfian on 19/10/24.
//

import UIKit
import Vision

enum VisionServiceError: Error {
    case invalidImage
    case noTextFound
    case noFaceFound
    case invalidSampleBuffer
    case noResultsFound
}

final class VisionService {
    // Text recognition from UIImage
    func recognizeText(in image: UIImage, language: String = "id") async throws -> [VNRecognizedTextObservation] {
        let handler = try createImageRequestHandler(from: image)
        let request = VNRecognizeTextRequest()
        request.recognitionLanguages = [language]
        request.recognitionLevel = .accurate

        let results = try await performVisionRequest(on: handler, request: request)
        return results as? [VNRecognizedTextObservation] ?? []
    }

    // Face detection from UIImage
    func detectFaces(in image: UIImage) async throws -> [VNFaceObservation] {
        let handler = try createImageRequestHandler(from: image)
        let request = VNDetectFaceRectanglesRequest()
        #if targetEnvironment(simulator)
            request.usesCPUOnly = true
        #endif

        let results = try await performVisionRequest(on: handler, request: request)
        return results as? [VNFaceObservation] ?? []
    }

    // Face detection from CMSampleBuffer
    func detectFaces(in sampleBuffer: CMSampleBuffer) async throws -> [VNFaceObservation] {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            throw VisionServiceError.invalidSampleBuffer
        }

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        let request = VNDetectFaceRectanglesRequest()
        #if targetEnvironment(simulator)
            request.usesCPUOnly = true
        #endif

        let results = try await performVisionRequest(on: handler, request: request)
        return results as? [VNFaceObservation] ?? []
    }

    func classify(image: UIImage, mlmodel: MLModel) async throws -> [VNClassificationObservation] {
        let handler = try createImageRequestHandler(from: image)
        let model = try VNCoreMLModel(for: mlmodel)
        let request = VNCoreMLRequest(model: model)
        #if targetEnvironment(simulator)
            request.usesCPUOnly = true
        #endif
        let results = try await performVisionRequest(on: handler, request: request)
        return results as? [VNClassificationObservation] ?? []
    }

    // MARK: Example KTP

    // - Width = 8.56 cm
    // - Height = 5.398 cm
    // - Aspect Ratio = (Width / Height) = (8.56 cm / 5.398 cm) = 1.585
    // - Minimum & Maximum Aspect Ration = +- 5%
    // - Minimum = 1.585 * 0.95 = 1.506
    // - Maximum = 1.585 * 1.05 = 1.664

    func detectRect(
        in image: UIImage,
        minimumAspectRatio: VNAspectRatio = 1.506,
        maximumAspectRatio: VNAspectRatio = 1.664,
        minimumSize: Float = 0.5,
        maximumObservations: Int = 1
    ) async throws -> [VNRectangleObservation] {
        let handler = try createImageRequestHandler(from: image)
        let request = VNDetectRectanglesRequest()
        // Configure the request for square detection
        request.minimumAspectRatio = minimumAspectRatio
        request.maximumAspectRatio = maximumAspectRatio
        request.minimumSize = minimumSize
        request.maximumObservations = maximumObservations
        #if targetEnvironment(simulator)
            request.usesCPUOnly = true
        #endif

        let results = try await performVisionRequest(on: handler, request: request)
        return results as? [VNRectangleObservation] ?? []
    }

    // Generic method to handle Vision requests
    private func performVisionRequest<T: VNRequest>(on handler: VNImageRequestHandler, request: T) async throws -> [Any] {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                try handler.perform([request])
                continuation.resume(returning: request.results ?? [])
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    // Helper method to create a VNImageRequestHandler from an image
    private func createImageRequestHandler(from image: UIImage) throws -> VNImageRequestHandler {
        guard let cgImage = image.cgImage else {
            throw VisionServiceError.invalidImage
        }
        return VNImageRequestHandler(cgImage: cgImage, options: [:])
    }
}
