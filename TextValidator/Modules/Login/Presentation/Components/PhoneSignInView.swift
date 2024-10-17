//
//  PhoneSignInView.swift
//  TextValidator
//
//  Created by Alfian on 15/10/24.
//

import SwiftUI

struct PhoneSignInView: View {
    @StateObject var viewModel: LoginViewModel

    var body: some View {
        EmptyView()
//        VStack(alignment: .leading, spacing: 8) {
//            HStack {
//                Button {} label: {
//                    Group {
//                        if viewModel.isLoading {
//                            ProgressView()
//                        } else {
//                            HStack {
//                                Text(viewModel.countryCode.flag)
//                                Text(viewModel.countryCode.dialCode)
//                                    .font(.subheadline)
//                            }
//                        }
//                    }
//                }
//
//                TextField("Phone", text: $viewModel.phone)
//                    .disabled(viewModel.isLoading)
//            }
//        }
//        .modifier(TextFieldModifier(label: "Phone", errorMessage: viewModel.phoneError))
    }
}
