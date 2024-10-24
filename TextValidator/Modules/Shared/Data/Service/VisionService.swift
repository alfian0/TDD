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

    // Helper method for setting up device for simulator testing
    private func configureFaceDetectionRequest(_ request: VNDetectFaceRectanglesRequest) {
        #if targetEnvironment(simulator)
            if #available(iOS 17.0, *) {
                if let cpuDevice = MLComputeDevice.allComputeDevices.first(where: { $0.description.contains("MLCPUComputeDevice") }) {
                    request.setComputeDevice(.some(cpuDevice), for: .main)
                }
            } else {
                request.usesCPUOnly = true
            }
        #endif
    }

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
        configureFaceDetectionRequest(request)

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
        configureFaceDetectionRequest(request)

        let results = try await performVisionRequest(on: handler, request: request)
        (results as? [VNFaceObservation])?.first?.landmarks
        return results as? [VNFaceObservation] ?? []
    }
}
