//
//  CameraView.swift
//  TextValidator
//
//  Created by Alfian on 31/10/24.
//

import AVFoundation
import SwiftUI

struct CameraPreview: UIViewControllerRepresentable {
    let captureSession: AVCaptureSession

    func makeUIViewController(context _: Context) -> UIViewController {
        let viewController = UIViewController()
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = UIScreen.main.bounds

        viewController.view.backgroundColor = .black
        viewController.view.layer.addSublayer(previewLayer)
        captureSession.startRunning()

        return viewController
    }

    func updateUIViewController(_: UIViewController, context _: Context) {}
}

struct CameraView: View {
    private var cameraRepo = AVKitCameraCaptureRepositoryImpl()
    @State private var capturedImage: UIImage? = nil
    @State private var isCapturing = false

    var body: some View {
        ZStack {
            CameraPreview(captureSession: cameraRepo.captureSession)
                .ignoresSafeArea()

            VStack {
                Spacer()

                Button(action: capturePhoto) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 70, height: 70)
                        .opacity(isCapturing ? 0.5 : 1.0)
                }
                .disabled(isCapturing)
            }

            VStack {
                Spacer()

                HStack {
                    if let image = capturedImage {
                        ZStack {
                            Color.white
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                        }
                        .frame(width: 80, height: 80)
                    }

                    Spacer()
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            cameraRepo.captureSession.startRunning()
        }
        .onDisappear {
            cameraRepo.captureSession.stopRunning()
        }
    }

    private func capturePhoto() {
        isCapturing = true
        Task {
            do {
                let image = try await cameraRepo.scanDocument()
                capturedImage = image
            } catch {
                print("Failed to capture photo: \(error)")
            }
            isCapturing = false
        }
    }
}

#Preview {
    CameraView()
}
