//
//  ImagePickerRepositoryImpl.swift
//  TextValidator
//
//  Created by Alfian on 29/10/24.
//

import UIKit

class ImagePickerRepositoryImpl: NSObject, DocumentScannerRepository {
    private var completion: ((Result<[UIImage], Error>) -> Void)?

    func scanDocument(completion: @escaping (Result<[UIImage], any Error>) -> Void) {
        self.completion = completion
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self

        if let topController = UIApplication.topViewController() {
            topController.present(imagePickerController, animated: true)
        }
    }
}

extension ImagePickerRepositoryImpl: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let topController = UIApplication.topViewController(),
           let image = info[.originalImage] as? UIImage
        {
            topController.dismiss(animated: true) { [weak self] in
                self?.completion?(.success([image]))
            }
        }
    }

    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        if let topController = UIApplication.topViewController() {
            topController.dismiss(animated: true)
        }
    }
}
