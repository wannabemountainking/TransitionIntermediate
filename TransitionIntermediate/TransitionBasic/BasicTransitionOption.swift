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
	
    var body: some View {
		ScrollView {
			// 추가 버튼
			Button {
				// Action: 클릭하면 items에 FavoriteItem 인스턴스를 생성하고 items에 추가
				withAnimation(.easeInOut(duration: 1)) {
					items.append(FavoriteItem())
				}
			} label: {
				HStack {
					Image(systemName: "plus")
					Spacer()
					Text("추가")
				} //:HSTACK
				.font(.system(size: 24))
				.frame(width: 100, height: 50)
				.foregroundStyle(.white)
				.padding(.horizontal, 25)
				.background(
					RoundedRectangle(cornerRadius: 25)
						.fill(Color.indigo)
				)
			}
			.padding(20)
			
			// 즐겨찾기 목록
			ForEach(items, id: \.id) { item in
				ItemView(item: item)
					.frame(maxWidth: .infinity)
					.transition(.move(edge: .trailing))
			}
		}
		
		// 설명
		VStack(alignment: .leading, spacing: 10) {
			Text("+ 버튼 누르면 -> 새 행이 오른쪽에서 슬라이드 되며 등장")
			Text("x 누르면 -> 그 행만 오른쪽으로 슬라이드 되며 사라짐")
		}
    }
	
	private func ItemView(item: FavoriteItem) -> some View {
		
		RoundedRectangle(cornerRadius: 10)
			.fill(.white)
			.frame(width: 200, height: 50)
			.overlay {
				HStack {
					Text(item.name)
					Spacer()
					Button {
						// action : 클릭하면 items에서 해당 FavoriteItem 인스턴스가 삭제됨
						withAnimation(.easeInOut(duration: 1)) {
							items.removeAll(where: { $0.id == item.id })
						}
					} label: {
						Image(systemName: "xmark.circle.fill")
							.resizable()
							.frame(width: 30, height: 30)
							.foregroundStyle(.pink)
					}
				}
				.padding(.horizontal, 23)
			}
			.shadow(color: .gray.opacity(0.3), radius: 10, x: 5, y: 5)
	}
}

#Preview {
    BasicTransitionOption()
}
