//
//  AVKitCameraCaptureRepositoryImpl.swift
//  TextValidator
//
//  Created by Alfian on 31/10/24.
//

import AVFoundation
import SwiftUI

class AVKitCameraCaptureRepositoryImpl: NSObject, CameraCaptureRepository {
    @MainActor
    func getCapturedImage() async throws -> UIImage {
        return try await withCheckedThrowingContinuation { continuation in
            let imagePickerView = CameraView(viewModel: CameraViewModel()) { image in
                UIApplication.topViewController()?.dismiss(animated: true, completion: {
                    continuation.resume(returning: image)
                })
            }
            let imagePickerController = UIHostingController(rootView: imagePickerView)
            imagePickerController.modalPresentationStyle = .fullScreen
            if let topController = UIApplication.topViewController() {
                topController.present(imagePickerController, animated: true)
            }
        }
    }
}

@MainActor
final class CameraViewModel: NSObject, ObservableObject {
    @Published var capturedImage: UIImage? = nil
    @Published var isCapturing = false
    @Published var captureSession: AVCaptureSession? = nil
    private var photoOutput = AVCapturePhotoOutput()

    func captureImage() {
        isCapturing.toggle()
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .off
        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    func startSession() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        guard status == .authorized else {
            if status == .notDetermined {
                AVCaptureDevice.requestAccess(for: .video) { [weak self] status in
                    guard status else { return }
                    self?.startSession()
                }
            }
            return
        }

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

        guard captureSession.canAddOutput(photoOutput) else {
            return
        }

        photoOutput.connection(with: .video)?.videoOrientation = .landscapeRight
        captureSession.addOutput(photoOutput)
        captureSession.commitConfiguration()
        Task.detached {
            captureSession.startRunning()
        }
    }

    func stopSession() {
        Task(priority: .background) {
            captureSession?.stopRunning()
            captureSession = nil
        }
    }

    func reset() {
        capturedImage = nil
        startSession()
    }
}

extension CameraViewModel: @preconcurrency AVCapturePhotoCaptureDelegate {
    func photoOutput(_: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            return
        }

        guard let imageData = photo.fileDataRepresentation() else {
            return
        }

        guard let provider = CGDataProvider(data: imageData as CFData) else {
            return
        }

        guard let cgImage = CGImage(jpegDataProviderSource: provider, decode: nil, shouldInterpolate: true, intent: .defaultIntent) else {
            return
        }

//        let image = UIImage(cgImage: cgImage, scale: 1, orientation: UIDevice.current.orientation.uiImageOrientation)
        let image = UIImage(cgImage: cgImage)

        capturedImage = image
        isCapturing.toggle()
        stopSession()
    }
}

struct CameraView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @StateObject var viewModel: CameraViewModel
    var completion: (UIImage) -> Void

    var body: some View {
        ZStack {
            if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
                if let session = viewModel.captureSession {
                    GeometryReader { proxy in
                        CameraPreview(frame: proxy.frame(in: .global), captureSession: session)
                    }
                    .ignoresSafeArea()
                }

                if viewModel.capturedImage == nil {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blue, lineWidth: 4)
                        .aspectRatio(85.6 / 53.98, contentMode: .fit)
                        .background(Color.clear)
                        .overlay(
                            Text("Align KTP here")
                                .foregroundColor(.white)
                                .padding(4)
                                .background(Color.black.opacity(0.6))
                                .cornerRadius(4)
                                .padding(8),
                            alignment: .bottom
                        )
                        .padding()
                }

                if viewModel.capturedImage != nil {
                    HStack(spacing: 16) {
                        if let image = viewModel.capturedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                        } else {
                            Spacer()
                        }

                        VStack(alignment: .trailing) {
                            Button("Retake") {
                                viewModel.reset()
                            }

                            Spacer()

                            Button("Use Photo") {
                                guard let image = viewModel.capturedImage else { return }
                                completion(image)
                            }
                        }
                        .padding(.vertical, 32)
                    }
                    .ignoresSafeArea()
                } else {
                    HStack {
                        Spacer()

                        Button {
                            viewModel.captureImage()
                        } label: {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 70, height: 70)
                                .opacity(viewModel.isCapturing ? 0.5 : 1.0)
                        }
                        .disabled(viewModel.isCapturing)
                    }
                }
            } else {
                Text("Change camera access on the setting menu")
            }
        }
        .onAppear {
            viewModel.startSession()
            // Lock orientation
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            AppDelegate.orientationLock = .landscapeRight
        }
        .onDisappear {
            viewModel.stopSession()
            // Release lock orientation
            AppDelegate.orientationLock = .all
        }
    }
}

#Preview {
    CameraView(viewModel: CameraViewModel(), completion: { _ in })
}
