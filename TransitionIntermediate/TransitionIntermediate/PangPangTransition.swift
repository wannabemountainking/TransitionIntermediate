//
//  PangPangTransition.swift
//  TransitionIntermediate
//
//  Created by YoonieMac on 8/17/26.
//

import SwiftUI

struct PangPangTransition: View {
	
	@State private var isLiked: Bool = false
	@State private var showBurst: Bool = false
	@State private var timer: Timer? = nil
	
    var body: some View {
		VStack {
			ZStack(alignment: .center) {
				HStack(spacing: 20) {
					Image(systemName: isLiked ? "heart.fill" : "heart")
						.foregroundStyle(isLiked ? Color.red : .gray)
						.scaleEffect(isLiked ? 1.2 : 1.0)
						.animation(.easeInOut(duration: 0.2), value: isLiked)
					Text("좋아요")
				}
				.font(.largeTitle)
				.fontWeight(.bold)
				.onTapGesture {
					let willBeLiked = !isLiked
					
					withAnimation(.spring(response: 0.2, dampingFraction: 0.8)) {
						isLiked.toggle()
					}
					
					if willBeLiked {
						withAnimation(.spring(response: 0.2, dampingFraction: 0.8)) {
							showBurst = isLiked
						}
						
						timer = Timer.scheduledTimer(
							withTimeInterval: 0.6,
							repeats: false,
							block: { _ in
								withAnimation(.easeInOut(duration: 0.8)) {
									showBurst = false
								}
							}
						)
					}
				} //:HSTACK
				if showBurst {
					HStack {
						Image(systemName: "sparkles")
							.resizable()
							.frame(width: 50, height: 50)
							.foregroundStyle(.yellow)
					}
					.font(.largeTitle)
					.fontWeight(.heavy)
					.transition(.pangEffect)
				}
			} //:ZSTACK
		} //:VSTACK
		.padding()
    }
}

struct PangEffect: ViewModifier {
	
	let showBurst: Bool
	
	func body(content: Content) -> some View {
		content
			.rotationEffect(.degrees(showBurst ? 0 : 360), anchor: .center)
			.scaleEffect(showBurst ? 1.3 : 0.8)
			.offset(y: showBurst ? 60 : -200)
			.opacity(showBurst ? 1.0 : 0.0)
	}
}

extension AnyTransition {
	static var pangEffect: AnyTransition {
		.modifier(
			active: PangEffect(showBurst: false),
			identity: PangEffect(showBurst: true)
		)
	}
}

#Preview {
    PangPangTransition()
}
