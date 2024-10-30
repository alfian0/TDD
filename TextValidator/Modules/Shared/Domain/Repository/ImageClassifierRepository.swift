//
//  ImageClassifierRepository.swift
//  TextValidator
//
//  Created by Alfian on 29/10/24.
//

import UIKit

protocol ImageClassifierRepository {
    func classifyKTP(image: UIImage) async throws -> ClassificationResult?
}
