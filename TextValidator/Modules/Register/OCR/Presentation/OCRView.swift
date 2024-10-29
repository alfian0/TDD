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

            if let image = viewModel.idCardImage {
                Image(uiImage: image)
                    .resizable()
                    .onTapGesture {
                        viewModel.scanDocument()
                    }
            }

            VStack {
                TextField("Name", text: $viewModel.name)
                    .keyboardType(.namePhonePad)
                    .autocapitalization(.none)
                    .modifier(TextFieldModifier(label: "Name", errorMessage: viewModel.nameError))

                TextField("NIK", text: $viewModel.idNumber)
                    .keyboardType(.numberPad)
                    .autocapitalization(.none)
                    .modifier(TextFieldModifier(label: "NIK", errorMessage: viewModel.idNumberError))

                DatePicker("Date of Birth", selection: $viewModel.dateOfBirth, displayedComponents: .date)
                    .modifier(TextFieldModifier(label: "", errorMessage: viewModel.dateOfBirthError))

                Spacer()

                Button {} label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(LoadingButtonStyle(isLoading: false))
                .disabled(!viewModel.canSubmit)
            }
            .padding(.horizontal)
        }
        .onViewDidLoad {
            viewModel.scanDocument()
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
