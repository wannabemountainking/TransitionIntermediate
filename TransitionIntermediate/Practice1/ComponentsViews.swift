//
//  ComponentsViews.swift
//  TransitionIntermediate
//
//  Created by YoonieMac on 8/21/26.
//

import SwiftUI

struct ComponentsViews: View {
    var body: some View {
		ArticleCardView(
			article: Article(
				title: "Swift 6의 엄격한 동시성 모델, 무엇이 달라지나",
				source: "Swift.org",
				readingMinutes: 6,
				icon: "swift"
				),
			isBookmarked: true,
			onCardAction: {_ in }
		)
    }
}

struct ArticleCardView: View {
	
	let article: Article
	let isBookmarked: Bool
	let onCardAction: (Article) -> Void
	
	var body: some View {
		
		VStack(alignment: .leading, spacing: 15) {
			// 기사 아이콘
			Image(systemName: article.icon)
				.font(.title2)
				.foregroundStyle(.orange)
			// 기사 제목
			HStack(spacing: 10) {
				Text("제목  \(article.title)")
					.foregroundStyle(.secondary)
					.lineLimit(5)
			} //:HSTACK
			.font(.subheadline)
			.fontWeight(.semibold)
			// 기사 출처 및 읽는 데 걸리는 시간
			HStack(spacing: 10) {
				Text(article.source)
					.font(.caption)
				Text("\(article.readingMinutes.formatted())분")
			}
			.foregroundStyle(.purple.opacity(0.8))
			
			HStack {
				Spacer()
				Image(systemName: )
			}
			
		} //:VSTACK
		.frame(maxWidth: 130)
	}
}

#Preview {
    ComponentsViews()
}
