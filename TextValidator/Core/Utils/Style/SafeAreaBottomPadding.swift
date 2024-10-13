//
//  SafeAreaBottomPadding.swift
//  TextValidator
//
//  Created by Alfian on 09/10/24.
//

import SwiftUI

struct SafeAreaBottomPadding: ViewModifier {
    func body(content: Content) -> some View {
        if UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 {
            content.padding(.bottom)
        } else {
            content
        }
    }
}

extension View {
    func safeAreaBottomPadding() -> some View {
        modifier(SafeAreaBottomPadding())
    }
}
