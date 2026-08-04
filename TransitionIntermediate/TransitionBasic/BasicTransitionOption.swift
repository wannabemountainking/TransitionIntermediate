//
//  TransitionBasic.swift
//  TransitionIntermediate
//
//  Created by YoonieMac on 8/4/26.
//

import SwiftUI


struct FavoriteItem: Identifiable {
	static var index: Int = 0
	
	let id: UUID = UUID()
	let name: String
	
	init() {
		Self.index += 1
		self.name = "아이템 \(Self.index)"
	}
}

struct BasicTransitionOption: View {
	@State private var items: [FavoriteItem] = []
	@State private var itemSoonToBeAdded: FavoriteItem = FavoriteItem()
	
    var body: some View {
		ScrollView {
			Button {
				// Action
				withAnimation(.easeInOut(duration: 1)) {
					items.append(itemSoonToBeAdded)
				}
			} label: {
				Text("<#placeholder#>")
			}
		}
    }
}

#Preview {
    BasicTransitionOption()
}
