//
//  iOSCheckboxToggleStyle.swift
//  TextValidator
//
//  Created by Alfian on 07/10/24.
//

import SwiftUI

struct iOSCheckboxToggleStyle: ToggleStyle {
	func makeBody(configuration: Configuration) -> some View {
		Button(action: {
			configuration.isOn.toggle()
		}, label: {
			HStack(alignment: .top) {
				Image(systemName: configuration.isOn ? "checkmark.square" : "square")
					.frame(width: 24, height: 24)
				configuration.label
					.multilineTextAlignment(.leading)
			}
		})
	}
}
