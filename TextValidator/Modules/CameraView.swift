//
//  CameraView.swift
//  TextValidator
//
//  Created by Alfian on 31/10/24.
//

import AVFoundation
import SwiftUI

struct CameraPreview: UIViewRepresentable {
    let frame: CGRect
    let captureSession: AVCaptureSession

    func makeUIView(context _: Context) -> UIView {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        let view = UIView(frame: frame)
        view.backgroundColor = .black
        view.layer.addSublayer(previewLayer)
        previewLayer.session = captureSession
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = frame
        previewLayer.connection?.videoOrientation = UIDevice.current.orientation.videoOrientation
        return view
    }

    func updateUIView(_ view: UIView, context _: Context) {
        guard let previewLayer = view.layer.sublayers?.first as? AVCaptureVideoPreviewLayer else {
            return
        }
        previewLayer.frame = frame
        previewLayer.connection?.videoOrientation = UIDevice.current.orientation.videoOrientation
    }
}

struct CameraView: View {
    private var cameraRepo = AVKitCameraCaptureRepositoryImpl()
    @State private var capturedImage: UIImage? = nil
    @State private var isCapturing = false
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var isLansscape: Bool { verticalSizeClass == .compact }

    var body: some View {
        ZStack {
            GeometryReader { proxy in
                CameraPreview(frame: proxy.frame(in: .global), captureSession: cameraRepo.captureSession)
            }
            .ignoresSafeArea()

            if isLansscape {
                HStack {
                    Action
                }

                HStack {
                    Result
                }
            } else {
                VStack {
                    Action
                }

                VStack {
                    Result
                }
            }
        }
        .onAppear {
            Task(priority: .background) {
                cameraRepo.captureSession.startRunning()
            }
        }
        .onDisappear {
            Task(priority: .background) {
                cameraRepo.captureSession.stopRunning()
            }
        }
    }

    private var Action: some View {
        Group {
            Spacer()

            Button(action: capturePhoto) {
                Circle()
                    .fill(Color.white)
                    .frame(width: 70, height: 70)
                    .opacity(isCapturing ? 0.5 : 1.0)
            }
            .disabled(isCapturing)
        }
    }

    private var Result: some View {
        Group {
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
