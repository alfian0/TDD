//
//  CropKTPUseCase.swift
//  TextValidator
//
//  Created by Alfian on 30/10/24.
//

import UIKit

final class CropKTPUseCase {
    private let visionService: VisionService

    init(visionService: VisionService) {
        self.visionService = visionService
    }

    func exec(image: UIImage) async throws -> UIImage {
        guard let grayscale = applyGrayscale(to: image) else {
            return image
        }
        let observations = try await visionService.detectRect(in: grayscale)
        guard let firstRectangle = observations.first else {
            return image
        }

        let croppedImage = cropRectangle(from: image, boundingBox: firstRectangle.boundingBox)

        return croppedImage ?? image
    }

    // MARK: - Grayscale and High-Contrast Filter

    private func applyGrayscale(to image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }

        let width = cgImage.width
        let height = cgImage.height
        let rect = CGRect(x: 0, y: 0, width: width, height: height)

        // Create a grayscale color space
        guard let grayColorSpace = CGColorSpace(name: CGColorSpace.linearGray) else { return nil }

        // Create a bitmap graphics context
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width,
            space: grayColorSpace,
            bitmapInfo: CGImageAlphaInfo.none.rawValue
        ) else { return nil }

        // Draw the original image into the grayscale context
        context.draw(cgImage, in: rect)

        // Extract the grayscale image
        guard let grayscaleCGImage = context.makeImage() else { return nil }

        return UIImage(cgImage: grayscaleCGImage)
    }

    // MARK: - Crop Rectangle from Image

    private func cropRectangle(from image: UIImage, boundingBox: CGRect) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }

        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)

        // Convert bounding box to image coordinates
        let rect = CGRect(
            x: boundingBox.origin.x * width,
            y: (1 - boundingBox.origin.y - boundingBox.height) * height,
            width: boundingBox.width * width,
            height: boundingBox.height * height
        )

        // Crop the image using the bounding box
        guard let croppedCGImage = cgImage.cropping(to: rect) else { return nil }

        return UIImage(cgImage: croppedCGImage, scale: image.scale, orientation: image.imageOrientation)
    }
}
