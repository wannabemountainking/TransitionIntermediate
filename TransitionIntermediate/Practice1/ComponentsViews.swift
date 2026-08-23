//
//  ComponentsViews.swift
//  TransitionIntermediate
//
//  Created by YoonieMac on 8/21/26.
//

import SwiftUI

struct ComponentsViews: View {
	let namespace: Namespace.ID
	
    var body: some View {
		ArticleCardView(
			article: Article(
				title: "Swift 6의 엄격한 동시성 모델, 무엇이 달라지나",
				source: "Swift.org",
				readingMinutes: 6,
				icon: "swift"
				),
			namespace: namespace,
			hasBookmarked: true,
			onCardAction: { _ in }
		)
    }
}

struct ArticleCardView: View {
	
	let article: Article
	let namespace: Namespace.ID
	let hasBookmarked: Bool
	let onCardAction: (BookmarkAction) -> Void
	
	enum BookmarkAction {
		case add(article: Article)
		case remove(article: Article)
	}
	
	var body: some View {
		
		VStack(alignment: .leading, spacing: 15) {
			// 기사 아이콘
			Image(systemName: article.icon)
				.font(.title2)
				.foregroundStyle(.orange)
				.matchedGeometryEffect(id: "\(article.id)Icon", in: namespace)
			// 기사 제목
			HStack(spacing: 10) {
				Text("제목  \(article.title)")
					.foregroundStyle(.secondary)
					.lineLimit(5)
					.matchedGeometryEffect(id: "\(article.id)Title", in: namespace)
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
				Image(systemName: hasBookmarked ? "star.fill" : "star")
					.font(.title2)
					.foregroundStyle(.yellow)
					.frame(maxWidth: .infinity)
					.contentShape(Rectangle())
					.onTapGesture {
						if hasBookmarked {
							onCardAction(.remove(article: article))
						} else {
							onCardAction(.add(article: article))
						}
						
					}
				Spacer()
			}
			
		} //:VSTACK
		.frame(maxWidth: 130)
		.matchedGeometryEffect(id: "\(article.id)Background", in: namespace)
	}
}

struct BookmarkRowView: View {
	var bookmarkItem: BookmarkItem
	let namespace: Namespace.ID
	let onRowAction: (RowAction) -> Void
	
	enum RowAction {
		case remove
		case toggleRead
	}
	
	var body: some View {
		HStack(spacing: 15) {
			Image(systemName: bookmarkItem.article.icon)
				.font(.title3)
				.foregroundStyle(.orange)
				.matchedGeometryEffect(id: "\(bookmarkItem.article.id)Icon", in: namespace)
			
			Text("제목  \(bookmarkItem.article.title)")
				.font(.subheadline)
				.foregroundStyle(.secondary)
				.lineLimit(3)
				.matchedGeometryEffect(id: "\(bookmarkItem.article.id)Title", in: namespace)
			
			Spacer()
			
			HStack {
				Text(bookmarkItem.hasRead ? "✓ 읽음" : "◯ 안읽음")
					.foregroundStyle(bookmarkItem.hasRead ? Color.green : .pink.opacity(0.7))
					.onTapGesture {
						onRowAction(.toggleRead)
					}
				Image(systemName: "trash")
					.foregroundStyle(.red)
					.onTapGesture {
						onRowAction(.remove)
					}
			}
			.font(.headline)
			.frame(alignment: .center)
		} //:HSTACK
		.matchedGeometryEffect(id: "\(bookmarkItem.id)Background", in: namespace)
		.padding(.horizontal, 20)
	}
}

struct EmptyBookmarkView: View {
	
	let onDismiss: () -> Void
	
	var body: some View {
		ContentUnavailableView {
			// Label
			Label("북마크한 책이 없습니다", systemImage: "cart")
		} description: {
			Text("마음에 드는 책을 골라주세요")
		} actions: {
			PurpleButton(
				title: "책 고르기",
				action: {
					withAnimation(.spring) {
						onDismiss()
					}
				}
			)
		}
	}
}

#Preview {
	@Previewable @Namespace var namespace
    ComponentsViews(namespace: namespace)
}

#Preview("RowView") {
	@Previewable @Namespace var namespace
	let bookmark: BookmarkItem = BookmarkItem(article: Articles.articles[0])
	
	BookmarkRowView(
		bookmarkItem: bookmark,
		namespace: namespace,
		onRowAction: {_ in}
	)
}
