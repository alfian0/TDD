//
//  UIDeviceOrientation+Extension.swift
//  TextValidator
//
//  Created by Alfian on 31/10/24.
//

import UIKit

extension UIDeviceOrientation {
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
