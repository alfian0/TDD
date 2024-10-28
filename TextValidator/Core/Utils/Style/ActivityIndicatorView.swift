//
//  ActivityIndicatorView.swift
//  TextValidator
//
//  Created by Alfian on 28/10/24.
//

import SwiftUI
import UIKit

struct ActivityIndicatorView: UIViewRepresentable {
    @Binding var isAnimating: Bool
    var style: UIActivityIndicatorView.Style = .medium
    var color: UIColor = .gray

    func makeUIView(context _: Context) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: style)
        activityIndicator.color = color
        return activityIndicator
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context _: Context) {
        if isAnimating {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}
