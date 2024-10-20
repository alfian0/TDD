//
//  TextRecognizerModel.swift
//  TextValidator
//
//  Created by Alfian on 20/10/24.
//

import Foundation

struct TextRecognizerModel {
    let boundingBox: CGRect
    let topLeft: CGPoint
    let topRight: CGPoint
    let bottomLeft: CGPoint
    let bottomRight: CGPoint
    let candidate: String
    let confidence: Float
}
