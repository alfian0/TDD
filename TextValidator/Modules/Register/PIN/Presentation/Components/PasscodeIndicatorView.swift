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
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color("D5D5D6"), lineWidth: 1)

                    ZStack {
                        Circle()
                            .fill(passcode.count > index ? .primary : Color(.white))

                        Circle()
                            .stroke(Color.gray, lineWidth: 1)
                    }
                    .frame(width: 8, height: 8)
                }
                .frame(width: 45, height: 45)
                .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    PasscodeIndicatorView(passcode: .constant("12"), count: 5)
}
