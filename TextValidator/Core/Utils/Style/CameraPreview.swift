//
//  CameraPreview.swift
//  TextValidator
//
//  Created by Alfian on 03/11/24.
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
        previewLayer.backgroundColor = UIColor.yellow.cgColor
        previewLayer.connection?.videoOrientation = AppDelegate.orientationLock.videoOrientation
        return view
    }

    func updateUIView(_ view: UIView, context _: Context) {
        guard let previewLayer = view.layer.sublayers?.first as? AVCaptureVideoPreviewLayer else {
            return
        }
        previewLayer.frame = frame
        previewLayer.connection?.videoOrientation = AppDelegate.orientationLock.videoOrientation
    }
}

extension UIInterfaceOrientationMask {
    var uiImageOrientation: UIImage.Orientation {
        switch self {
        case .portrait: .right
        case .portraitUpsideDown: .left
        case .landscapeLeft: .up
        case .landscapeRight: .down
        default: UIDevice.current.orientation.uiImageOrientation
        }
    }

    var videoOrientation: AVCaptureVideoOrientation {
        switch self {
        case .portrait: .portrait
        case .portraitUpsideDown: .portraitUpsideDown
        case .landscapeLeft: .landscapeRight
        case .landscapeRight: .landscapeRight
        default: UIDevice.current.orientation.videoOrientation
        }
    }
}
