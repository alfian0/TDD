//
//  OTPView.swift
//  TextValidator
//
//  Created by Alfian on 03/10/24.
//

import SwiftUI

struct OTPView: View {
    @StateObject var viewModel: OTPViewModel
    @FocusState var isKeyboardShowing: Bool

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)

                Text(viewModel.subtitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 16) {
                OTPTextBoxView(
                    otpcode: $viewModel.otpText,
                    isKeyboardShowing: _isKeyboardShowing,
                    count: viewModel.count
                )
                .padding()
                .background {
                    TextField("", text: $viewModel.otpText.limit(viewModel.count))
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                        .frame(width: 1, height: 1)
                        .opacity(0.1)
                        .blendMode(.screen)
                        .focused($isKeyboardShowing)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    isKeyboardShowing.toggle()
                }

                VStack(alignment: .leading) {
                    Text("Dont receive code ?")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    HStack {
                        Text("Resend code")
                            .font(.subheadline)
                            .foregroundColor(.blue.opacity(viewModel.isEnableOtherAction ? 1 : 0.5))
                            .contentShape(Rectangle())
                            .onTapGesture {
                                guard viewModel.isEnableOtherAction else { return }
                                viewModel.start()
                            }

                        Text("or")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Text("Change number")
                            .font(.subheadline)
                            .foregroundColor(.blue.opacity(viewModel.isEnableOtherAction ? 1 : 0.5))
                            .contentShape(Rectangle())
                            .onTapGesture {
                                guard viewModel.isEnableOtherAction else { return }
                            }

                        Text("\(viewModel.timer)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal)

            Spacer()

            Button(action: {
                viewModel.goToPIN()
            }) {
                Text("Continue")
                    .frame(minHeight: 24)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(viewModel.canSubmit ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .disabled(!viewModel.canSubmit)
        }
        .safeAreaBottomPadding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {} label: {
                    Image(systemName: "questionmark.circle")
                }
            }

            ToolbarItem(placement: .keyboard) {
                Button("Done") {
                    isKeyboardShowing.toggle()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}

#Preview {
    OTPView(
        viewModel: OTPViewModel(
            type: .phone(code: .dummy, phone: "87738091779"),
            verificationID: "",
            otpVerifyUsecase: DefaultOTPVerifyUsecase(service: OTPVerifyService()),
            coordinator: OTPCoordinator()
        )
    )
}
