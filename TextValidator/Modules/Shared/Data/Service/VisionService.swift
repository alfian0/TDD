//
//  VisionService.swift
//  TextValidator
//
//  Created by Alfian on 19/10/24.
//

import Swinject
import UIKit
import Vision

class VisionServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(VisionService.self) { _ in
            VisionService()
        }
    }
}

enum VisionServiceError: Error {
    case invalidImage
    case noTextFound
}

final class VisionService {
    func textRecognizer(image: UIImage) async throws -> [VNRecognizedTextObservation] {
        // Convert the UIImage to CGImage
        guard let cgImage = image.cgImage else {
            throw VisionServiceError.invalidImage
        }

        // Use a throwing continuation to handle the asynchronous nature of VNRequest
        return try await withCheckedThrowingContinuation { continuation in
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

            // Create the text recognition request
            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: error) // Resume with error if it fails
                    return
                }

                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(throwing: VisionServiceError.noTextFound) // Resume with an error if no text was found
                    return
                }

                // Resume with the populated data model
                continuation.resume(returning: observations)
            }

            // Configure request options
            request.recognitionLanguages = ["id"]
            request.recognitionLevel = .accurate

            // Perform the text recognition request
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: error) // Resume with error if the handler fails
            }
        }
    }
}
