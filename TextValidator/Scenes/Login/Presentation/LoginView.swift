//
//  LoginView.swift
//  TextValidator
//
//  Created by Alfian on 03/10/24.
//

import SwiftUI

struct LoginView: View {
	var body: some View {
		VStack {
			VStack(alignment: .leading, spacing: 8) {
				Text("Hi, Welcome Back!")
					.frame(maxWidth: .infinity, alignment: .leading)
					.font(.title)
				
				Text("It's good to see you again")
					.frame(maxWidth: .infinity, alignment: .leading)
					.font(.body)
					.foregroundColor(.secondary)
			}
			.padding(.horizontal)
			
			VStack(alignment: .leading, spacing: 8) {
				VStack(alignment: .leading, spacing: 8) {
					Text("Username")
						.font(.subheadline)
					TextField("Username", text: .constant(""))
						.keyboardType(.emailAddress)
						.autocapitalization(.none)
					Divider()
					Text("")
						.font(.caption)
						.foregroundColor(.red)
				}
				
				HStack(spacing: 4) {
					Text("Forgot you password?")
						.font(.subheadline)
						.foregroundColor(.secondary)
					
					Button {
						
					} label: {
						Text("Click here")
							.font(.subheadline)
					}
				}
			}
			.padding(.horizontal)
			
			Spacer()
			
			Button(action: {
				
			}) {
				Text("Continue")
					.frame(minHeight: 24)
					.frame(maxWidth: .infinity)
					.padding(.vertical, 8)
					.background(Color.blue)
					.foregroundColor(.white)
					.cornerRadius(8)
			}
			.padding(.horizontal)
		}
		.safeAreaBottomPadding()
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button {
					
				} label: {
					Image(systemName: "questionmark.circle")
				}
			}
		}
	}
}

#Preview {
	NavigationView {
		LoginView()
	}
}
