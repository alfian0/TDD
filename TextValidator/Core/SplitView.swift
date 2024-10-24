//
//  SplitView.swift
//  TextValidator
//
//  Created by Alfian on 23/10/24.
//

import SwiftUI

struct SplitView<LeftContent: View, RightContent: View>: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var isLandscape: Bool { verticalSizeClass == .compact }
    var isIphone: Bool { horizontalSizeClass == .compact }

    let leftContent: LeftContent
    let rightContent: RightContent

    init(
        leftContent: @escaping () -> LeftContent,
        rightContent: @escaping () -> RightContent
    ) {
        self.leftContent = leftContent()
        self.rightContent = rightContent()
    }

    var body: some View {
        Group {
            #if os(iOS)
                if isIphone {
                    if isLandscape {
                        HStackLayout
                    } else {
                        VStackLayout
                    }
                } else {
                    GeometryReader { reader in
                        if reader.size.width > reader.size.height {
                            HStackLayout
                        } else {
                            VStackLayout
                        }
                    }
                }
            #else
                // macOS, or other platforms
                HStackLayout
            #endif
        }
    }

    // Horizontal Layout for iPads and iPhone Landscape
    private var HStackLayout: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                leftContent
                    .frame(maxWidth: .infinity)
                ScrollView(.vertical) {
                    rightContent
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: geometry.size.height)
                }
            }
        }
    }

    // Vertical Layout for iPhone Portrait
    private var VStackLayout: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    leftContent
                        .frame(maxWidth: .infinity)
                    rightContent
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, max((UIScreen.main.bounds.width - 458) / 2, 0))
                }
                .frame(minHeight: geometry.size.height)
            }
        }
    }
}

#Preview {
    SplitView {
        Text("ss")
    } rightContent: {
        Color.blue
    }
}
