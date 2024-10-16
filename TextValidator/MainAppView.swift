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
            Button {
                coordinator.present(.login)
            } label: {
                Text("Login")
            }
            .buttonStyle(.bordered)

            Button {
                coordinator.present(.register)
            } label: {
                Text("Register")
            }
            .buttonStyle(.borderedProminent)
        }
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
