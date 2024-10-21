//
//  CountrySearchListView.swift
//  TextValidator
//
//  Created by Alfian on 03/10/24.
//

import SwiftUI
import Swinject

class CountrySearchListViewAssembly: Assembly {
    func assemble(container: Container) {
        container.register(CountrySearchListView.self) { (r, s: CountryCodeModel, i: [CountryCodeModel], ds: @escaping (CountryCodeModel) -> Void, dd: @escaping () -> Void) in
            guard let viewModel = r.resolve(CountryCodeViewModel.self, arguments: s, i, ds, dd) else {
                fatalError()
            }
            return CountrySearchListView(viewModel: viewModel)
        }
    }
}

struct CountrySearchListView: View {
    @StateObject var viewModel: CountryCodeViewModel

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color("8A8A8D"))
                TextField("Search", text: $viewModel.search)
            }
            .padding(.all, 8)
            .background(RoundedRectangle(cornerRadius: 8).fill(Color("EFEFF0")))
            .padding(.all, 8)
            Divider()
            List {
                ForEach(viewModel.filteredItems) { item in
                    CountryCodeItemView(viewModel: item, isSelected: item.name == viewModel.selected.name)
                        .onTapGesture {
                            viewModel.didSelect(item)
                        }
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Select your country calling code")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.didDismiss()
                } label: {
                    Image(systemName: "xmark")
                        .padding()
                }
            }
        }
    }
}

#Preview {
    let coordinator = CountryCodeCoordinator()

    NavigationControllerWrapper(coordinator: coordinator)
        .edgesIgnoringSafeArea(.all)
        .onViewDidLoad {
            coordinator.start(selected: .dummy, items: [.dummy]) { _ in

            } didDismiss: {}
        }
}
