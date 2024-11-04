//
//  CameraCaptureRepository.swift
//  TextValidator
//
//  Created by Alfian on 29/10/24.
//

import UIKit

protocol CameraCaptureRepository {
    func getCapturedImage() async throws -> UIImage
}
