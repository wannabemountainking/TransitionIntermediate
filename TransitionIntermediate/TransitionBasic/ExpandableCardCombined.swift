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
	
	@State private var isExpanded: Bool = false
	let card: CardInfo = CardInfo(title: "나의 카드", description: "이 카드를 만든 당신은 성공합니다. 그렇게 당신이 마음먹었으니까요")
	
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ExpandableCardCombined()
}
