//
//  DocumentScannerRepository.swift
//  TextValidator
//
//  Created by Alfian on 29/10/24.
//

import UIKit

protocol DocumentScannerRepository {
    func scanDocument() async throws -> UIImage
}
