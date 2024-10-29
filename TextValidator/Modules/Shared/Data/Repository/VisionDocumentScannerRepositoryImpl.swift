//
//  VisionDocumentScannerRepositoryImpl.swift
//  TextValidator
//
//  Created by Alfian on 29/10/24.
//

import UIKit
import VisionKit

class VisionDocumentScannerRepositoryImpl: NSObject, DocumentScannerRepository {
    // Store the continuation to resume the async function
    private var continuation: CheckedContinuation<UIImage, Error>?

    @MainActor
    func scanDocument() async throws -> UIImage {
        // Present the document scanner view controller and wait for completion
        return try await withCheckedThrowingContinuation { continuation in
            let documentCameraViewController = VNDocumentCameraViewController()
            documentCameraViewController.delegate = self

            // Store the continuation to resume later in delegate methods
            self.continuation = continuation

            if let topController = UIApplication.topViewController() {
                topController.present(documentCameraViewController, animated: true)
            }
        }
    }
}

extension VisionDocumentScannerRepositoryImpl: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        if let topController = UIApplication.topViewController() {
            // Dismiss the camera and pass the result
            let lastPageIndex = scan.pageCount - 1
            let scannedImage = scan.imageOfPage(at: lastPageIndex)
            topController.dismiss(animated: true) { [weak self] in
                // Resume the async function with the scanned image
                self?.continuation?.resume(returning: scannedImage)
                self?.continuation = nil
            }
        }
    }

    func documentCameraViewControllerDidCancel(_: VNDocumentCameraViewController) {
        if let topController = UIApplication.topViewController() {
            topController.dismiss(animated: true) { [weak self] in
                // Resume with a cancellation error
                self?.continuation?.resume(throwing: NSError(domain: "DocumentScanner", code: -1, userInfo: [NSLocalizedDescriptionKey: "Scanning was cancelled"]))
                self?.continuation = nil
            }
        }
    }

    func documentCameraViewController(_: VNDocumentCameraViewController, didFailWithError error: Error) {
        if let topController = UIApplication.topViewController() {
            topController.dismiss(animated: true) { [weak self] in
                // Resume with the encountered error
                self?.continuation?.resume(throwing: error)
                self?.continuation = nil
            }
        }
    }
}
