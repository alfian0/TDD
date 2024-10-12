//
//  Binding+Extension.swift
//  TextValidator
//
//  Created by Alfian on 08/10/24.
//

import SwiftUI

extension Binding where Value == String {
	func limit(_ length: Int) -> Self {
		if wrappedValue.count > length {
			DispatchQueue.main.async {
				wrappedValue = String(wrappedValue.prefix(length))
			}
		}
		return self
	}
}
