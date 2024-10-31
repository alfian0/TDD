//
//  UIKitDocumentScannerRepositoryImpl.swift
//  TextValidator
//
//  Created by Alfian on 29/10/24.
//

import UIKit

class UIKitCameraCaptureRepositoryImpl: NSObject, CameraCaptureRepository {
    private var continuation: CheckedContinuation<UIImage, Error>?

    @MainActor
    func scanDocument() async throws -> UIImage {
        return try await withCheckedThrowingContinuation { continuation in
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .camera
            imagePickerController.delegate = self

            self.continuation = continuation

            if let topController = UIApplication.topViewController() {
                topController.present(imagePickerController, animated: true)
            }
        }
    }
}

extension UIKitCameraCaptureRepositoryImpl: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let topController = UIApplication.topViewController(),
           let image = info[.originalImage] as? UIImage
        {
            topController.dismiss(animated: true) { [weak self] in
                self?.continuation?.resume(returning: image)
                self?.continuation = nil
            }
        }
    }

    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        if let topController = UIApplication.topViewController() {
            topController.dismiss(animated: true) { [weak self] in
                // Resume with a cancellation error
                self?.continuation?.resume(throwing: NSError(domain: "DocumentScanner", code: -1, userInfo: [NSLocalizedDescriptionKey: "Scanning was cancelled"]))
                self?.continuation = nil
            }
        }
    }
}
