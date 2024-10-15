//
//  CountrySearchListViewController.swift
//  TextValidator
//
//  Created by Alfian on 04/10/24.
//

import SwiftUI
import UIKit

class CountrySearchListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    private var viewModel: CountryCodeViewModel
    private var tableView: UITableView!
    private var searchBar: UISearchBar!

    init(viewModel: CountryCodeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        viewModel.cancel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    private func setupUI() {
        view.backgroundColor = .white

        let titleLabel = UILabel()
        titleLabel.text = "Select your country calling code"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)

        let closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .systemBlue
        closeButton.addTarget(self, action: #selector(didDismiss), for: .touchUpInside)
        view.addSubview(closeButton)

        searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        view.addSubview(searchBar)

        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(CountryCodeItemCell.self, forCellReuseIdentifier: String(describing: CountryCodeItemCell.self))
        view.addSubview(tableView)

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupBindings() {
        // Bind search text to viewModel
        searchBar.searchTextField.addTarget(self, action: #selector(searchTextFieldDidChange), for: .editingChanged)

        // Reload tableView when filteredItems change
        //		viewModel.$filteredItems
        //			.receive(on: DispatchQueue.main)
        //			.sink { [weak self] _ in
        //				self?.tableView.reloadData()
        //			}
        //			.store(in: &viewModel.cancellables)
    }

    // Implement the target action method
    @objc private func searchTextFieldDidChange(_ textField: UISearchTextField) {
        // Update the viewModel with the search text
        viewModel.search = textField.text ?? ""
    }

    @objc private func didDismiss() {
        viewModel.didDismiss()
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.filteredItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CountryCodeItemCell.self), for: indexPath) as! CountryCodeItemCell

        let item = viewModel.filteredItems[indexPath.row]
        cell.configure(with: item, isSelected: viewModel.selected.name == item.name)

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = viewModel.filteredItems[indexPath.row]
        viewModel.didSelect(selectedItem)
    }

    // MARK: - UISearchBarDelegate

    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        viewModel.search = searchText
    }
}

// struct CountrySearchListViewControllerView: UIViewControllerRepresentable {
//	func makeUIViewController(context: Context) -> some UIViewController {
//		let vc = CountrySearchListViewController(viewModel: CountryCodeViewModel(
//			selected: .dummy,
//			items: try! Data.fromJSONFile("Dial")
//				.toCodable(with: [CountryCodeResponse].self)
//				.map {
//					CountryCodeModel(name: $0.name, flag: $0.flag, dialCode: $0.dialCode, code: $0.code)
//				}
//		) { item in
//			// didSelect action
//		} didDismiss: {
//			// didDismiss action
//		})
//		return vc // UINavigationController(rootViewController: vc)
//	}
//
//	func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
// }
//
// struct CountryCodeViewControllerPreview: PreviewProvider {
//	static var previews: some View {
//		CountrySearchListViewControllerView().edgesIgnoringSafeArea(.all)
//	}
// }
