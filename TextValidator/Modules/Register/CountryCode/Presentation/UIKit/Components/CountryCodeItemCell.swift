//
//  CountryCodeItemCell.swift
//  TextValidator
//
//  Created by Alfian on 04/10/24.
//

import SwiftUI
import UIKit

class CountryCodeItemCell: UITableViewCell {
    let flagLabel = UILabel()
    let countryLabel = UILabel()
    let dialCodeLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        flagLabel.translatesAutoresizingMaskIntoConstraints = false
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        dialCodeLabel.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [flagLabel, countryLabel, UIView(), dialCodeLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
    }

    func configure(with model: CountryCodeModel, isSelected: Bool) {
        flagLabel.text = model.flag
        countryLabel.text = model.name
        countryLabel.font = UIFont.systemFont(ofSize: 16, weight: isSelected ? .bold : .regular)
        countryLabel.textColor = isSelected ? .systemBlue : .black
        dialCodeLabel.text = model.dialCode
        dialCodeLabel.font = UIFont.systemFont(ofSize: 16, weight: isSelected ? .bold : .regular)
        dialCodeLabel.textColor = isSelected ? .systemBlue : .black
    }
}

struct CountryCodeItemCellView: UIViewRepresentable {
    func makeUIView(context _: Context) -> CountryCodeItemCell {
        return CountryCodeItemCell()
    }

    func updateUIView(_ uiView: CountryCodeItemCell, context _: Context) {
        uiView.configure(with: .dummy, isSelected: false)
    }
}

struct CountryCodeItemCellPreview: PreviewProvider {
    static var previews: some View {
        CountryCodeItemCellView()
            .previewLayout(.sizeThatFits)
    }
}
