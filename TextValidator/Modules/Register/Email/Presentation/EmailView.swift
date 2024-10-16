//
//  EmailView.swift
//  TextValidator
//
//  Created by Alfian on 03/10/24.
//

import SwiftUI

struct EmailView: View {
    @StateObject var viewModel: EmailViewModel

    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.viewState.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)

                Text(viewModel.viewState.subtitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)

            switch viewModel.viewState {
            case .formInput:
                EmailFormView(viewModel: viewModel)
            case .waitingForVerification:
                EmailVerificationView(viewModel: viewModel)
            }
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
    let coordinator = EmailCoordinatorImpl()

    NavigationControllerWrapper(coordinator: coordinator)
        .edgesIgnoringSafeArea(.all)
        .onViewDidLoad {
            coordinator.start(viewState: .formInput)
        }
}
