//
//  OTPTextBoxView.swift
//  TextValidator
//
//  Created by Alfian on 08/10/24.
//

import SwiftUI

struct OTPTextBoxView: View {
    @Binding var otpcode: String
    @Binding var isKeyboardShowing: Bool
    let count: Int

    var body: some View {
        HStack {
            ForEach(0 ..< count, id: \.self) { index in
                ZStack {
                    let status = isKeyboardShowing && otpcode.count == index
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(status ? .blue : Color("D5D5D6"), lineWidth: 1)
                        .animation(.easeInOut(duration: 0.2), value: status)

                    Text(code(at: index))
                }
                .frame(width: 45, height: 45)
                .frame(maxWidth: .infinity)
            }
        }
    }

    private func code(at index: Int) -> String {
        if index < otpcode.count {
            let startIndex = otpcode.startIndex
            let charIndex = otpcode.index(startIndex, offsetBy: index)
            return String(otpcode[charIndex])
        } else {
            return ""
        }
    }
}

#Preview {
    OTPTextBoxView(otpcode: .constant("12"), isKeyboardShowing: .constant(false), count: 6)
}
