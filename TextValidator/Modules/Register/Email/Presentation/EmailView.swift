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
        Group {
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
        .onAppear {
            Task {
                await viewModel.verification()
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
