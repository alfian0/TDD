//
//  CustomTextField.swift
//  TextValidator
//
//  Created by Alfian on 28/10/24.
//

import SwiftUI

struct CustomTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var becomeFirstResponder: Bool

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomTextField

        init(_ parent: CustomTextField) {
            self.parent = parent
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        return textField
    }

    func updateUIView(_ uiView: UITextField, context _: Context) {
        uiView.text = text
        if becomeFirstResponder {
            DispatchQueue.main.async {
                uiView.becomeFirstResponder()
            }
        } else {
            DispatchQueue.main.async {
                uiView.resignFirstResponder()
            }
        }
    }
}

#Preview {
    @State var text: String = ""
    @State var becomeFirstResponder: Bool = true
    CustomTextField(text: $text, becomeFirstResponder: $becomeFirstResponder)
}
