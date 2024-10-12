//
//  DialModel.swift
//  TextValidator
//
//  Created by Alfian on 01/10/24.
//

import Foundation

struct CountryCodeModel: Identifiable, Equatable {
	let id = UUID()
	let name: String
	let flag: String
	let dialCode: String
	let code: String
	
	static var dummy: CountryCodeModel {
		CountryCodeModel(
			name: "Indonesia",
			flag: "🇮🇩",
			dialCode: "+62",
			code: "ID"
		)
	}
}
