//
//  CameraView.swift
//  TextValidator
//
//  Created by Alfian on 31/10/24.
//

import AVFoundation
import SwiftUI

@MainActor
final class CameraViewModel: ObservableObject {
    @Published var capturedImage: UIImage? = nil
    @Published var isCapturing = false
    private let repository: AVKitCameraCaptureRepositoryImpl

    init(repository: AVKitCameraCaptureRepositoryImpl) {
        self.repository = repository
    }

    func getSession() -> AVCaptureSession {
        repository.getSession()
    }

    func captureImage() {
        Task {
            isCapturing = true
            defer {
                isCapturing = false
            }
            do {
                capturedImage = try await repository.getCapturedImage()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func startSession() {
        Task(priority: .background) {
            repository.getSession().startRunning()
        }
    }

    func stopSession() {
        Task(priority: .background) {
            repository.getSession().stopRunning()
        }
    }
}

struct CameraView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @StateObject var viewModel: CameraViewModel
    var isLansscape: Bool { verticalSizeClass == .compact }

    var body: some View {
        ZStack {
            GeometryReader { proxy in
                CameraPreview(frame: proxy.frame(in: .global), captureSession: viewModel.getSession())
            }
            .ignoresSafeArea()

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

#Preview {
    CameraView(viewModel: CameraViewModel(repository: AVKitCameraCaptureRepositoryImpl()))
}
