//
//  ContactInfoViewController.swift
//  TextValidator
//
//  Created by Alfian on 04/10/24.
//

import SwiftUI
import UIKit

class ContactInfoViewController: UIViewController {
    private lazy var fullnameTextField = createTextField(placeholder: "Fullname", keyboardType: .default)
    private lazy var fullnameErrorLabel = createErrorLabel()
    private lazy var phoneTextField = createTextField(placeholder: "Phone", keyboardType: .phonePad)
    private lazy var phoneErrorLabel = createErrorLabel()
    private lazy var countryButton = createCountryButton()
    private lazy var continueButton = createButton(title: "Continue")
    private lazy var tncCheckbox = createCheckbox()

    var viewModel: ContactInfoViewModel

    init(viewModel: ContactInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
//        viewModel.cancel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    private func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(didClickRightBarButton))

        let termsLabel = createFootNote()
        let fullnameLabel = createLabel(text: "Fullname")
        let phoneLabel = createLabel(text: "Phone Number")
        let hStackView = createHStack(arrangedSubviews: [
            countryButton,
            phoneTextField,
        ])
        let hStackView2 = createHStack(arrangedSubviews: [
            tncCheckbox,
            termsLabel,
        ])
        let label = createLoginLabel()
        let stackView = createVStack(arrangedSubviews: [
            fullnameLabel,
            fullnameTextField,
            createDivider(),
            fullnameErrorLabel,
            phoneLabel,
            hStackView,
            createDivider(),
            phoneErrorLabel,
            label,
            hStackView2,
            continueButton,
        ])

        NSLayoutConstraint.activate([
            phoneTextField.widthAnchor.constraint(lessThanOrEqualTo: hStackView.widthAnchor),
        ])

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
        ])
    }

    private func setupBindings() {
        fullnameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        countryButton.addTarget(self, action: #selector(didTapCountryCode), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        tncCheckbox.addTarget(self, action: #selector(didToggleTermsSwitch), for: .touchUpInside)

        viewModel.$fullnameError.sink { [weak self] result in
            self?.fullnameErrorLabel.text = result
        }
        .store(in: &viewModel.cancellables)

        viewModel.$phoneError.sink { [weak self] result in
            self?.phoneErrorLabel.text = result
        }
        .store(in: &viewModel.cancellables)

        viewModel.$canSubmit.sink { [weak self] result in
            self?.continueButton.isEnabled = result
            self?.continueButton.backgroundColor = result ? .systemBlue : .gray
        }
        .store(in: &viewModel.cancellables)

        viewModel.$countryCode.sink { [weak self] result in
            self?.countryButton.setTitle(result.flag + " " + result.dialCode, for: .normal)
        }
        .store(in: &viewModel.cancellables)
    }

    @objc private func didClickRightBarButton(_: UIBarButtonItem) {}

    @objc private func textFieldDidChange(_ textField: UITextField) {
        if textField == fullnameTextField {
            viewModel.fullname = textField.text ?? ""
        } else if textField == phoneTextField {
            viewModel.phone = textField.text ?? ""
        }
    }

    @objc private func didTapCountryCode() {
        viewModel.didTapCountryCode()
    }

    @objc private func didTapContinue() async {
        await viewModel.didTapCountinue()
    }

    @objc private func didToggleTermsSwitch(_ sender: UIButton) {
        sender.isSelected.toggle()
        viewModel.isAgreeToTnC = sender.isSelected
    }

    private func createFootNote() -> UILabel {
        let text = "By clicking Continue, you have agreed to Terms of Use and Privacy Policy"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.link, value: "TextValidator://TnC", range: text.getRangeOf("Terms of Use")!)
        attributedString.addAttribute(.link, value: "TextValidator://PC", range: text.getRangeOf("Privacy Policy")!)
        let label = UILabel()
        label.attributedText = attributedString
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        return label
    }

    private func createCheckbox() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return button
    }

    private func createButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    private func createTextField(placeholder: String, keyboardType: UIKeyboardType) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .none
        textField.keyboardType = keyboardType
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }

    private func createCountryButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return button
    }

    private func createHStack(arrangedSubviews: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .top
        return stackView
    }

    private func createVStack(arrangedSubviews: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }

    private func createDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = UIColor(named: "D5D5D6")
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        return divider
    }

    private func createErrorLabel() -> UILabel {
        let label = UILabel()
        label.heightAnchor.constraint(equalToConstant: 12).isActive = true
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func createLoginLabel() -> UILabel {
        let text = "Already have an account ? Login"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.link, value: "TextValidator://Login", range: text.getRangeOf("Login")!)

        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = attributedString

        return label
    }
}

// struct ContactInfoViewControllerView: UIViewControllerRepresentable {
//	func makeUIViewController(context: Context) -> some UIViewController {
//		let viewModel = ContactInfoViewModel(
//			fullnameValidationUsecase: FullNameValidationUsecase(),
//			phoneValidationUsecase: PhoneValidationUsecase(),
//			getCountryCodeUsecase: DefaultCountryCodeRepository(service: DefaultCountryCodeService()),
//			checkContactInfoUsecase: DefaultCheckContactInfoRepository(service: DefaultCheckContactInfoService()))
//		let vc = ContactInfoViewController(viewModel: viewModel)
//		return UINavigationController(rootViewController: vc)
//	}
//
//	func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//
//	}
// }
//
// struct ContactInfoViewControllerPreview: PreviewProvider {
//	static var previews: some View {
//		ContactInfoViewControllerView().edgesIgnoringSafeArea(.all)
//	}
// }
