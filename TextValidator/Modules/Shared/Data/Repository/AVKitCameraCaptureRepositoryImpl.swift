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

        photoOutput.connection(with: .video)?.videoOrientation = UIDevice.current.orientation.videoOrientation
        captureSession.addOutput(photoOutput)
        captureSession.commitConfiguration()
        captureSession.startRunning()
    }

    func stopSession() {
        captureSession?.stopRunning()
        captureSession = nil
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

        let image = UIImage(cgImage: cgImage, scale: 1, orientation: UIDevice.current.orientation.uiImageOrientation)

        capturedImage = image
        isCapturing.toggle()
        stopSession()
    }
}

struct CameraView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @StateObject var viewModel: CameraViewModel
    var isLansscape: Bool { verticalSizeClass == .compact }
    var completion: (UIImage) -> Void

    var body: some View {
        ZStack {
            if let session = viewModel.captureSession {
                GeometryReader { proxy in
                    CameraPreview(frame: proxy.frame(in: .global), captureSession: session)
                }
                .ignoresSafeArea()
            }

            if let image = viewModel.capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }

            if isLansscape {
                HStack {
                    Action
                }
            } else {
                VStack {
                    Action
                }
            }
        }
        .onAppear {
            viewModel.startSession()
        }
        .onDisappear {
            viewModel.stopSession()
        }
    }

    private var Action: some View {
        Group {
            Spacer()

            if viewModel.capturedImage != nil {
                if isLansscape {
                    VStack {
                        Result
                    }
                } else {
                    HStack {
                        Result
                    }
                }
            } else {
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
    }

    private var Result: some View {
        Group {
            Button("Retake") {
                viewModel.reset()
            }

            Spacer()

            Button("Use Photo") {
                guard let image = viewModel.capturedImage else { return }
                completion(image)
            }
        }
        .padding()
    }
}

#Preview {
    CameraView(viewModel: CameraViewModel(), completion: { _ in })
}
