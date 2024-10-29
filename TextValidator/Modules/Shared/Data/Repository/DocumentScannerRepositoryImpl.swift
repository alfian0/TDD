//
//  DocumentScannerRepositoryImpl.swift
//  TextValidator
//
//  Created by Alfian on 29/10/24.
//

import UIKit
import VisionKit

class DocumentScannerRepositoryImpl: NSObject, DocumentScannerRepository {
    private var completion: ((Result<[UIImage], Error>) -> Void)?

    func scanDocument(completion: @escaping (Result<[UIImage], Error>) -> Void) {
        self.completion = completion
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self

        if let topController = UIApplication.topViewController() {
            topController.present(documentCameraViewController, animated: true)
        }
    }
}

extension DocumentScannerRepositoryImpl: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        if let topController = UIApplication.topViewController() {
            let lastPageIndex = scan.pageCount - 1
            let scannedImage = scan.imageOfPage(at: lastPageIndex)
            topController.dismiss(animated: true) { [weak self] in
                self?.completion?(.success([scannedImage]))
            }
        }
    }

    func documentCameraViewControllerDidCancel(_: VNDocumentCameraViewController) {
        if let topController = UIApplication.topViewController() {
            topController.dismiss(animated: true)
        }
    }

    func documentCameraViewController(_: VNDocumentCameraViewController, didFailWithError error: Error) {
        if let topController = UIApplication.topViewController() {
            topController.dismiss(animated: true) { [weak self] in
                self?.completion?(.failure(error))
            }
        }
    }
}
