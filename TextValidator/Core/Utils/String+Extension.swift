//
//  String+Extension.swift
//  TextValidator
//
//  Created by Alfian on 06/10/24.
//

import Foundation

extension String {
	func getRangeOf(_ string: String) -> NSRange? {
		let range = self.range(of: string)
		if let range = range {
			return NSRange(range, in: self)
		}
		return nil
	}
}
