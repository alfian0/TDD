//
//  PasscodeIndicatorView.swift
//  TextValidator
//
//  Created by Alfian on 08/10/24.
//

import SwiftUI

struct PasscodeIndicatorView: View {
    @Binding var passcode: String
    let count: Int

    var body: some View {
        HStack {
            ForEach(0 ..< count, id: \.self) { index in
                Circle()
                    .fill(passcode.count > index ? .primary : Color(.white))
                    .frame(width: 20, height: 20)
                    .overlay {
                        Circle()
                            .stroke(.primary, lineWidth: 1)
                    }
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    PasscodeIndicatorView(passcode: .constant("12"), count: 5)
}
