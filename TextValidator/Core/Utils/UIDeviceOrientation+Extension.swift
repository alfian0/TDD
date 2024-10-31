//
//  UIDeviceOrientation+Extension.swift
//  TextValidator
//
//  Created by Alfian on 31/10/24.
//

import AVFoundation
import UIKit

extension UIDeviceOrientation {
    var videoOrientation: AVCaptureVideoOrientation {
        switch self {
        case .portraitUpsideDown: .portraitUpsideDown
        case .landscapeLeft: .landscapeRight
        case .landscapeRight: .landscapeLeft
        default: .portrait
        }
    }

    var uiImageOrientation: UIImage.Orientation {
        switch self {
        case .landscapeLeft: .up
        case .portrait: .right
        case .landscapeRight: .down
        case .portraitUpsideDown: .left
        default: .right
        }
    }
}
