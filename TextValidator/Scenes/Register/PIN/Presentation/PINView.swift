//
//  PINView.swift
//  TextValidator
//
//  Created by Alfian on 08/10/24.
//

import SwiftUI

struct PINView: View {
	@StateObject var viewModel: PINViewModel
	
	var body: some View {
		VStack(spacing: 8) {
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
			
			Spacer()
			
			PasscodeIndicatorView(
				passcode: $viewModel.passcode,
				count: viewModel.count
			)
			.padding()
		
			Text(viewModel.passcodeError ?? "")
				.font(.caption)
				.foregroundColor(.red)
			
			Spacer()
			
			NumpadView(
				passcode: $viewModel.passcode,
				count: viewModel.count
			)
		}
		.toolbar {
			ToolbarItem(placement: .topBarLeading) {
				Button {
					viewModel.back()
				} label: {
					Text("Back")
				}
			}
		}
	}
}

#Preview {
	let coordinator = PINCoordinator()
	
	NavigationControllerWrapper(coordinator: coordinator)
		.edgesIgnoringSafeArea(.all)
		.onAppear {
			coordinator.start()
		}
}
