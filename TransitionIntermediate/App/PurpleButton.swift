//
//  PurpleButton.swift
//  TransitionIntermediate
//
//  Created by YoonieMac on 8/7/26.
//

import SwiftUI

struct PurpleButton: View {
	let title: String
	let action: () -> Void
	
    var body: some View {
		Button(
			action: action,
			label: {
				Text(title)
					.font(.title2)
					.fontWeight(.semibold)
					.frame(maxWidth: .infinity)
					.padding(.vertical, 10)
			}
		)
		.buttonStyle(.borderedProminent)
		.foregroundStyle(.white)
		.padding(.horizontal)
		.tint(.indigo.opacity(0.8))
		.shadow(radius: 5)
    }
}

#Preview {
	PurpleButton(title: "에니메이션 실행") {
		
	}
}
