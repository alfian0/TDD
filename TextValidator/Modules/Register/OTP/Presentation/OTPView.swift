//
//  OTPView.swift
//  TextValidator
//
//  Created by Alfian on 03/10/24.
//

import SwiftUI

struct OTPView: View {
    @StateObject var viewModel: OTPViewModel

    var body: some View {
        VStack(spacing: 16) {
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
                ZStack {
                    CustomTextField(text: $viewModel.otpText.limit(viewModel.count), becomeFirstResponder: $viewModel.becomeFirstResponder)
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                        .frame(width: 1, height: 1)
                        .opacity(0.1)
                        .blendMode(.screen)

                    OTPTextBoxView(
                        otpcode: $viewModel.otpText,
                        isKeyboardShowing: $viewModel.becomeFirstResponder,
                        count: viewModel.count
                    )
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.becomeFirstResponder.toggle()
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
                                viewModel.resend()
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
                                viewModel.change()
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
                viewModel.next()
            }) {
                Text("Continue")
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
            .disabled(!viewModel.canSubmit)
            .buttonStyle(LoadingButtonStyle(isLoading: false))
        }
        .padding(.bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {} label: {
                    Image(systemName: "questionmark.circle")
                }
            }

//            ToolbarItem(placement: .keyboard) {
//                Button("Done") {
//                    viewModel.becomeFirstResponder.toggle()
//                }
//                .frame(maxWidth: .infinity, alignment: .trailing)
//            }
        }
        .onAppear {
            viewModel.start()
        }
    }
}

#Preview {
    let coordinator = OTPCoordinator()

    NavigationControllerWrapper(coordinator: coordinator)
        .edgesIgnoringSafeArea(.all)
        .onViewDidLoad {
            coordinator.start(title: "", subtitle: "", count: 6, duration: 10) {} didChange: {} didSuccess: { _ in
            }
        }
}
