//
//  PasswordView.swift
//  TextValidator
//
//  Created by Alfian on 08/10/24.
//

import SwiftUI

struct PasswordView: View {
	@StateObject var viewModel: PasswordViewModel = PasswordViewModel()
	
	var body: some View {
		VStack {
			VStack(alignment: .leading, spacing: 8) {
				Text("Set password")
					.frame(maxWidth: .infinity, alignment: .leading)
					.font(.title)
				
				Text("Set up your password for login")
					.frame(maxWidth: .infinity, alignment: .leading)
					.font(.body)
					.foregroundColor(.secondary)
			}
			.padding(.horizontal)
			
			VStack(spacing: 16) {
				SecureField("Password", text: $viewModel.password)
					.keyboardType(.emailAddress)
					.autocapitalization(.none)
				Divider()
				
				SecureField("Repeat Password", text: $viewModel.repassword)
					.keyboardType(.emailAddress)
					.autocapitalization(.none)
				Divider()
				
				HStack(spacing: 4) {
					ForEach(PasswordStrength.allCases, id:\.self) { value in
						Color("D5D5D6")
							.overlay {
								viewModel.passwordStrength.color.opacity(value.rawValue <= viewModel.passwordStrength.rawValue ? 1 : 0)
									.animation(.easeInOut, value: viewModel.passwordStrength)
							}
					}
				}
				.frame(height: 4)
			}
			.padding()
			
			Spacer()
			
			Button {
				
			} label: {
				Text("Continue")
					.frame(minHeight: 24)
					.frame(maxWidth: .infinity)
					.padding(.horizontal)
					.padding(.vertical, 8)
					.background(.blue)
					.foregroundColor(.white)
					.cornerRadius(8)
			}
			.padding(.horizontal)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
		.safeAreaBottomPadding()
	}
}

#Preview {
	PasswordView()
}
