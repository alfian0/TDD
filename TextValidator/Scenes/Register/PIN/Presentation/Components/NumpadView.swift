//
//  NumpadView.swift
//  TextValidator
//
//  Created by Alfian on 08/10/24.
//

import SwiftUI

struct NumpadView: View {
	@Binding var passcode: String
	let count: Int
	
	let columns: [GridItem] = [
		.init(),
		.init(),
		.init()
	]
	
	var body: some View {
		LazyVGrid(columns: columns) {
			ForEach(1...9, id:\.self) { index in
				Button {
					add(index)
				} label: {
					Text("\(index)")
						.font(.title)
						.frame(maxWidth: .infinity)
						.padding(.vertical)
						.contentShape(.rect)
				}
			}
			
			Button {
				
			} label: {
				
			}
			
			Button {
				add(0)
			} label: {
				Text("0")
					.font(.title)
					.frame(maxWidth: .infinity)
					.padding(.vertical)
					.contentShape(.rect)
			}
			
			Button {
				remove()
			} label: {
				Image(systemName: "delete.backward")
					.font(.title)
					.frame(maxWidth: .infinity)
					.padding(.vertical)
					.contentShape(.rect)
			}
		}
		.foregroundStyle(.primary)
	}
	
	private func add(_ value: Int) {
		if passcode.count < count {
			passcode += "\(value)"
		}
	}
	
	private func remove() {
		if !passcode.isEmpty {
			passcode.removeLast()
		}
	}
}

#Preview {
	NumpadView(passcode: .constant(""), count: 5)
}
