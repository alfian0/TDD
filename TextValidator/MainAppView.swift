//
//  MainAppView.swift
//  TextValidator
//
//  Created by Alfian on 14/10/24.
//

import SwiftUI

struct MainAppView: View {
    var coordinator: MainAppCoordinatorImpl
    @State private var capturedImage: UIImage?
    @State private var showDocumentCamera = false
    @State private var name: String = ""

    var body: some View {
        VStack {
            Text(name)
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
                showDocumentCamera.toggle()
            } label: {
                Text("Show scanner")
            }
        }
        .padding(.horizontal)
        .fullScreenCover(isPresented: $showDocumentCamera) {
            DocumentCameraView(image: $capturedImage)
                .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            guard let capturedImage = capturedImage else { return }
            Task {
                let result = await ExtractKTPUsecase(repository: VisionRepositoryImpl(visionService: VisionService())).exec(image: capturedImage)
                switch result {
                case let .success(data):
                    name = data.nama ?? ""
                    print(data)
                case let .failure(error):
                    print(error)
                }
            }
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
