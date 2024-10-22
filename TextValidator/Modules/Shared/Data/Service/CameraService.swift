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
    private(set) var queue = DispatchQueue(label: "video.capture")
    private var photoOutput = AVCapturePhotoOutput()
    private var videoOutput = AVCaptureVideoDataOutput()
    private var imageContinuation: CheckedContinuation<UIImage, Error>?
    private var videoContinuation: CheckedContinuation<CMSampleBuffer, Error>?

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

    func addInput() {
        captureSession = AVCaptureSession()

        guard let captureSession = captureSession else {
            return
        }

        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
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
    }

    func addPhotoOutput(session: AVCaptureSession) {
        guard session.canAddOutput(photoOutput) else {
            return
        }

        session.addOutput(photoOutput)
        session.commitConfiguration()
    }

    func addVideoOutput(session: AVCaptureSession) {
        guard session.canAddOutput(videoOutput) else {
            return
        }

        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as NSString: NSNumber(value: kCVPixelFormatType_32BGRA)] as [String: Any]
        videoOutput.setSampleBufferDelegate(self, queue: queue)
        let videoOrientation = videoOutput.connection(with: .video)
        videoOrientation?.videoOrientation = .portrait

        session.addOutput(videoOutput)
        session.commitConfiguration()
    }

    func startCapture() async throws -> UIImage {
        return try await withCheckedThrowingContinuation { continuation in
            imageContinuation = continuation
            let settings = AVCapturePhotoSettings()
            photoOutput.capturePhoto(with: settings, delegate: self)
        }
    }

    func startCapture() async throws -> CMSampleBuffer {
        return try await withCheckedThrowingContinuation { continuation in
            videoContinuation = continuation
        }
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension CameraService: AVCapturePhotoCaptureDelegate {
    func photoOutput(_: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            imageContinuation?.resume(throwing: error)
            return
        }

        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData)
        else {
            imageContinuation?.resume(throwing: CameraError.captureFailed)
            return
        }

        imageContinuation?.resume(returning: image)
    }
}

// MARK: AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraService: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from _: AVCaptureConnection) {
        videoContinuation?.resume(returning: sampleBuffer)
    }
}

enum CameraError: Error {
    case unauthorized
    case captureFailed
}
