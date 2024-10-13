//
//  EmailView.swift
//  TextValidator
//
//  Created by Alfian on 03/10/24.
//

import SwiftUI

struct EmailView: View {
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Add your email")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)

                Text("Please input your personal email address to receive any notification")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 8) {
                Text("Email")
                    .font(.subheadline)
                TextField("Email", text: .constant(""))
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                Divider()
                Text("")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            .padding(.horizontal)

            Spacer()

            VStack {
                Button {} label: {
                    Text("Continue")
                        .frame(minHeight: 24)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button {} label: {
                    Text("Skip")
                }
            }
            .padding(.horizontal)
            .safeAreaBottomPadding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {} label: {
                    Image(systemName: "questionmark.circle")
                }
            }
        }
    }
}

#Preview {
    EmailView()
}
