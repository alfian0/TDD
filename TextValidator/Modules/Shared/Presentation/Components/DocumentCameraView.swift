//
//  DocumentCameraView.swift
//  TextValidator
//
//  Created by Alfian on 20/10/24.
//

import SwiftUI
import VisionKit

struct DocumentCameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) var dismiss

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let documentCameraVC = VNDocumentCameraViewController()
        documentCameraVC.delegate = context.coordinator
        return documentCameraVC
    }

    func updateUIViewController(_: VNDocumentCameraViewController, context _: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var parent: DocumentCameraView

        init(_ parent: DocumentCameraView) {
            self.parent = parent
        }

        func documentCameraViewController(_: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            let lastPageIndex = scan.pageCount - 1
            parent.image = scan.imageOfPage(at: lastPageIndex)
        }

        func documentCameraViewControllerDidCancel(_: VNDocumentCameraViewController) {
            parent.dismiss()
        }

        func documentCameraViewController(_: VNDocumentCameraViewController, didFailWithError _: Error) {
            parent.dismiss()
        }
    }
}
