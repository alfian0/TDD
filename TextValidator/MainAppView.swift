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
        SplitView {
            ZStack {
                Color("EFEFF0")
                Image("img_error")
            }
        } rightContent: {
            VStack {
                Spacer()
                Button {
                    coordinator.present(.login)
                } label: {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.automatic)

                Button {
                    coordinator.present(.register)
                } label: {
                    Text("Register")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.automatic)

                Button {
                    coordinator.present(.ocr)
                } label: {
                    Text("Show scanner")
                }
            }
            .padding()
            .fixedSize(horizontal: false, vertical: true)
        }
        .ignoresSafeArea()
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
