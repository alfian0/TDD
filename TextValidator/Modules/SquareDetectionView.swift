//
//  SquareDetectionView.swift
//  TextValidator
//
//  Created by Alfian on 30/10/24.
//

import SwiftUI
import Vision

struct SquareDetectionView: View {
    // Replace this with the name of your image asset
    @State private var selectedImage: UIImage? = UIImage(named: "ktp")
    @State private var detectedRectangles: [VNRectangleObservation] = []
    @State private var croppedImage: UIImage? = nil // Store cropped image

    var body: some View {
        VStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .overlay(
                        RectangleOverlay(rectangles: detectedRectangles)
                    )
                    .onAppear {
                        Task {
                            do {
                                croppedImage = try await CropKTPUseCase(visionService: VisionService()).exec(image: selectedImage)
                            } catch {
                                print(error)
                            }
                        }
                    }

                if let croppedImage = croppedImage {
                    Text("Cropped Image")
                        .font(.headline)
                        .padding(.top)
                    Image(uiImage: croppedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }
            } else {
                Text("No Image Available")
                    .font(.headline)
                    .padding()
            }
        }
    }
}

// MARK: - RectangleOverlay to Draw Lines

struct RectangleOverlay: View {
    let rectangles: [VNRectangleObservation]

    var body: some View {
        GeometryReader { geometry in
            ForEach(rectangles, id: \.self) { rectangle in
                Path { path in
                    let topLeft = CGPoint(
                        x: rectangle.topLeft.x * geometry.size.width,
                        y: (1 - rectangle.topLeft.y) * geometry.size.height
                    )
                    let topRight = CGPoint(
                        x: rectangle.topRight.x * geometry.size.width,
                        y: (1 - rectangle.topRight.y) * geometry.size.height
                    )
                    let bottomLeft = CGPoint(
                        x: rectangle.bottomLeft.x * geometry.size.width,
                        y: (1 - rectangle.bottomLeft.y) * geometry.size.height
                    )
                    let bottomRight = CGPoint(
                        x: rectangle.bottomRight.x * geometry.size.width,
                        y: (1 - rectangle.bottomRight.y) * geometry.size.height
                    )

                    path.move(to: topLeft)
                    path.addLine(to: topRight)
                    path.addLine(to: bottomRight)
                    path.addLine(to: bottomLeft)
                    path.closeSubpath()
                }
                .stroke(Color.red, lineWidth: 2)
            }
        }
    }
}

// Preview
#Preview {
    SquareDetectionView()
}
