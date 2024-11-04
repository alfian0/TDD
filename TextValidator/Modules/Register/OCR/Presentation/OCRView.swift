//
//  OCRView.swift
//  TextValidator
//
//  Created by Alfian on 21/10/24.
//

import SwiftUI

struct OCRView: View {
    @StateObject var viewModel: OCRViewModel

    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Identity Document Confirmation")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)

                Text("Make sure your data matches the information on your ID card")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)

            ZStack {
                if let image = viewModel.idCardImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .onTapGesture {
                            viewModel.captureKTP()
                        }
                }

                if viewModel.isLoading {
                    ProgressView()
                }
            }

            VStack {
                TextField("Name", text: $viewModel.name)
                    .keyboardType(.namePhonePad)
                    .autocapitalization(.none)
                    .modifier(TextFieldModifier(label: "Name", errorMessage: viewModel.nameError))
                    .disabled(viewModel.isLoading)

                TextField("NIK", text: $viewModel.idNumber)
                    .keyboardType(.numberPad)
                    .autocapitalization(.none)
                    .modifier(TextFieldModifier(label: "NIK", errorMessage: viewModel.idNumberError))
                    .disabled(viewModel.isLoading)

                DatePicker("Date of Birth", selection: $viewModel.dateOfBirth, displayedComponents: .date)
                    .modifier(TextFieldModifier(label: "", errorMessage: viewModel.dateOfBirthError))
                    .disabled(viewModel.isLoading)

                Spacer()

                Button {} label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(LoadingButtonStyle(isLoading: viewModel.isLoading))
                .disabled(!viewModel.canSubmit)
            }
            .padding(.horizontal)
        }
        .onViewDidLoad {
            viewModel.captureKTP()
        }
        .onAppear {
            AppDelegate.orientationLock = .all
        }
        .toolbar {
//            ToolbarItem(placement: .keyboard) {
//                Button("Done") {
//                    hideKeyboard()
//                }
//                .frame(maxWidth: .infinity, alignment: .trailing)
//            }
        }
    }
}

#Preview {
    NavigationView {
        AppAssembler.shared.resolver.resolve(OCRView.self, argument: OCRViewCoordinator())
    }
}
