//
//  CameraPreviewView.swift
//  TextValidator
//
//  Created by Alfian on 19/10/24.
//

import AVFoundation
import SwiftUI

struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context _: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        let cameraPreview = AVCaptureVideoPreviewLayer(session: session)
        cameraPreview.frame = view.frame
        cameraPreview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(cameraPreview)
        return view
    }

    func updateUIView(_: UIView, context _: Context) {}
}
