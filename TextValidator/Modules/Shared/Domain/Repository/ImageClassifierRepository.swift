//
//  ImageClassifierRepository.swift
//  TextValidator
//
//  Created by Alfian on 29/10/24.
//

import UIKit

protocol ImageClassifierRepository {
    func classify(image: UIImage) async throws -> ClassificationResult?
}
