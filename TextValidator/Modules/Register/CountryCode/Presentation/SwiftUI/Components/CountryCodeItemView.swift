//
//  CountryCodeItemView.swift
//  TextValidator
//
//  Created by Alfian on 04/10/24.
//

import SwiftUI

struct CountryCodeItemView: View {
    let viewModel: CountryCodeModel
    let isSelected: Bool

    var body: some View {
        HStack {
            Text(viewModel.flag)
            Text(viewModel.name)
                .font(isSelected ? .body.bold() : .body)
                .foregroundColor(isSelected ? .blue : .primary)
            Spacer()
            Text(viewModel.dialCode)
                .font(isSelected ? .body.bold() : .body)
                .foregroundColor(isSelected ? .blue : .primary)
        }
    }
}

#Preview {
    CountryCodeItemView(viewModel: .dummy, isSelected: false)
}
