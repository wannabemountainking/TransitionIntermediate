//
//  ExpandableCardCombined.swift
//  TransitionIntermediate
//
//  Created by YoonieMac on 8/4/26.
//

import SwiftUI


struct CardInfo: Identifiable {
	let id = UUID()
	let title: String
	let description: String
}

struct ExpandableCardCombined: View {
    
	let cards: [CardInfo] = [
		CardInfo(
			title: "나의 카드",
			description: "이 카드를 만든 나는 반드시 성공합니다. 그것을 당신이 원하기 때문입니다"
		),
		CardInfo(
			title: "너의 카드",
			description: "이 카드를 만든 너는 반드시 성공합니다. 그것을 당신이 원하기 때문입니다"
		),
		CardInfo(
			title: "우리의 카드",
			description: "이 카드를 만든 우리는 반드시 성공합니다. 그것을 당신이 원하기 때문입니다"
		)
	]
	
    var body: some View {
		ScrollView {
            ForEach(cards, id: \.id) { card in
				VStack(spacing: 10) {
                    CardView(card: card)
                        .padding()
				}
				.background(
					RoundedRectangle(cornerRadius: 20)
						.fill(.white)
						.shadow(radius: 5)
				)
				.padding()
			}
		}
    }
}

struct CardView: View {
    @State private var isExpanded: Bool = false
    let card: CardInfo
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(card.title)
                Spacer()
                
                Image(systemName: "chevron.up")
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    .onTapGesture {
                        withAnimation(
                            .spring(response: 0.4, dampingFraction: 0.6)) {
                                isExpanded.toggle()
                            }
                    }
            }
            .font(.title)
            .fontWeight(.semibold)
            if isExpanded {
                Divider()
                    .foregroundStyle(.black.opacity(0.8))
                    .frame(height: 2)
                    .transition(
                        .scale(scale: 0.2, anchor: .top)
                        .combined(with: .opacity)
                    )
                DetailView(card: card)
            }
        }
    }
}

struct DetailView: View {
    let card: CardInfo
    
    var body: some View {
        
        Text(card.description)
            .font(.title3)
            .fontWeight(.ultraLight)
            .transition(
                .scale(scale: 0.2, anchor: .top)
                .combined(with: .opacity)
            )
            .padding(.top, 10)
    }
}

#Preview {
    ExpandableCardCombined()
}
