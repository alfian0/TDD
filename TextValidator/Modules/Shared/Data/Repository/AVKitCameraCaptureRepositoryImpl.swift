//
//  AVKitCameraCaptureRepositoryImpl.swift
//  TextValidator
//
//  Created by Alfian on 31/10/24.
//

import AVFoundation
import UIKit

class AVKitCameraCaptureRepositoryImpl: NSObject, CameraCaptureRepository {
    private(set) var captureSession = AVCaptureSession()
    private var queue = DispatchQueue(label: "video.capture")
    private var photoOutput = AVCapturePhotoOutput()
    private var imageContinuation: CheckedContinuation<UIImage, Error>?

    override init() {
        super.init()
        configure(position: .back)
    }

    func scanDocument() async throws -> UIImage {
        try await capturePhoto(flashMode: .off)
    }

    private func configure(position: AVCaptureDevice.Position) {
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) else {
            return
        }

        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
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

    private func capturePhoto(flashMode: AVCaptureDevice.FlashMode) async throws -> UIImage {
        return try await withCheckedThrowingContinuation { continuation in
            imageContinuation = continuation
            let settings = AVCapturePhotoSettings()
            settings.flashMode = flashMode
            photoOutput.capturePhoto(with: settings, delegate: self)
        }
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension AVKitCameraCaptureRepositoryImpl: AVCapturePhotoCaptureDelegate {
    func photoOutput(_: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            imageContinuation?.resume(throwing: error)
            return
        }

        guard let imageData = photo.fileDataRepresentation() else {
            imageContinuation?.resume(throwing: CameraError.captureFailed)
            return
        }

        guard let provider = CGDataProvider(data: imageData as CFData) else {
            imageContinuation?.resume(throwing: CameraError.captureFailed)
            return
        }

        guard let cgImage = CGImage(jpegDataProviderSource: provider, decode: nil, shouldInterpolate: true, intent: .defaultIntent) else {
            imageContinuation?.resume(throwing: CameraError.captureFailed)
            return
        }

        let image = UIImage(cgImage: cgImage, scale: 1, orientation: UIDevice.current.orientation.uiImageOrientation)

        imageContinuation?.resume(returning: image)
    }
}
