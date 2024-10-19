//
//  CameraService.swift
//  TextValidator
//
//  Created by Alfian on 19/10/24.
//

import AVFoundation
import UIKit

class CameraService: NSObject {
    private(set) var captureSession: AVCaptureSession?
    private var photoOutput = AVCapturePhotoOutput()
    private var completion: ((Result<UIImage, Error>) -> Void)?
    private var imageContinuation: CheckedContinuation<UIImage, Error>?

    func isCameraAuthorized() async throws -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return true
        case .notDetermined:
            return try await withCheckedThrowingContinuation { continuation in
                AVCaptureDevice.requestAccess(for: .video) { status in
                    continuation.resume(returning: status)
                }
            }
        default:
            return false
        }
    }

    func configureCamera() {
        captureSession = AVCaptureSession()

        guard let captureSession = captureSession else {
            return
        }

        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)

        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!) else {
            return
        }

        captureSession.beginConfiguration()

        guard captureSession.canAddInput(videoDeviceInput) else {
            return
        }

        captureSession.addInput(videoDeviceInput)

        guard captureSession.canAddOutput(photoOutput) else {
            return
        }

        captureSession.addOutput(photoOutput)

        captureSession.commitConfiguration()
    }

    func captureImage(completion _: @escaping (Result<UIImage, Error>) -> Void) {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    func startCapture() async throws -> UIImage {
        return try await withCheckedThrowingContinuation { continuation in
            imageContinuation = continuation
            let settings = AVCapturePhotoSettings()
            photoOutput.capturePhoto(with: settings, delegate: self)
        }
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension CameraService: AVCapturePhotoCaptureDelegate {
    func photoOutput(_: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            completion?(.failure(error))
            imageContinuation?.resume(throwing: error)
            return
        }

        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData)
        else {
            completion?(.failure(CameraError.captureFailed))
            imageContinuation?.resume(throwing: CameraError.captureFailed)
            return
        }

        completion?(.success(image))
        imageContinuation?.resume(returning: image)
    }
}

enum CameraError: Error {
    case unauthorized
    case captureFailed
}
