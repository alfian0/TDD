//
//  VisionRepository.swift
//  TextValidator
//
//  Created by Alfian on 22/10/24.
//

import UIKit

protocol VisionRepository {
    func textRecognizer(image: UIImage) async throws -> [TextRecognizerModel]
}
