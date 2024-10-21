//
//  MainAppView.swift
//  TextValidator
//
//  Created by Alfian on 14/10/24.
//

import SwiftUI

struct MainAppView: View {
    var coordinator: MainAppCoordinatorImpl

    var body: some View {
        VStack {
            Spacer()
            Button {
                coordinator.present(.login)
            } label: {
                Text("Login")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            Button {
                coordinator.present(.register)
            } label: {
                Text("Register")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Button {
                coordinator.present(.ocr)
            } label: {
                Text("Show scanner")
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    let coordinator = MainAppCoordinatorImpl()

    NavigationControllerWrapper(coordinator: coordinator)
        .edgesIgnoringSafeArea(.all)
        .onViewDidLoad {
            coordinator.start()
        }
}
