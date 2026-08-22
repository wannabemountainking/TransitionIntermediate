//
//  ArticleBookmakrManager.swift
//  TransitionIntermediate
//
//  Created by YoonieMac on 8/21/26.
//

import SwiftUI

struct ArticleBookmarkMGEView: View {
	// properties
	@State private var bookmarks: [BookmarkItem] = []
    @State private var showingBookmarks: Bool = false
	@Namespace private var articleNamespace
	let articles: [Article] = Articles.articles
	
    var body: some View {
        // 토스트를 위해 ZStack 사용
		ZStack {
			VStack(spacing: 15) {
				// Header 뷰
				ArticleHeaderView
				Divider()
				
				// articles 뷰
				ScrollView {
					LazyVGrid(
						columns: [
							GridItem(.flexible()),
							GridItem(.flexible())
						],
						spacing: 10,
						content: {
							ForEach(articles) { article in
								ArticleCardView(
									article: article,
									namespace: articleNamespace,
									hasBookmarked: bookmarks.contains(where: { $0.id == article.id }),
									onCardAction: { action in
										// MARK: - 아티클 카드를 누르면 생기는 메서드
										// 조건부 렌더링: 별표시를 누르면 bookmarks에 추가(이미 있으면 생략), isBookmarked.toggle() 변경
										withAnimation(
											.spring(
												response: 0.5,
												dampingFraction: 0.8
											)
										) {
											switch action {
											case .add(let article):
												addToBookmarks(article: article)
											case .remove(let article):
												removeArticleFromBookmarks(article: article)
											}
										}
									}
								)
							}
						}
					)
				}
				
				Spacer()
			} //:VSTACK
			
		} //:ZSTACK
    }
	
	private func articleToBookmarkItem(article: Article) -> BookmarkItem {
		return BookmarkItem(article: article, hasRead: false)
	}
	
	private func addToBookmarks(article: Article) {
		let item = articleToBookmarkItem(article: article)
		bookmarks.append(item)
	}
	
	private func removeArticleFromBookmarks(article: Article) {
		if let index = bookmarks.firstIndex(where: { $0.id == article.id }) {
			bookmarks.remove(at: index)
		}
	}
    	
	// MARK: - HeaderView Component
	private var ArticleHeaderView: some View {
		HStack {
			Text("기사 피드")
			Spacer()
			Image(systemName: "bookmark.fill")
				.frame(width: 40, height: 40)
				.foregroundStyle(.mint)
				.overlay {
					Text("\(bookmarks.count)")
						.font(.system(size: 24))
						.foregroundStyle(.white)
						.offset(x: 15, y: -15)
						.background(
							Circle()
								.fill(Color.red)
								.frame(width: 30, height: 30)
								.foregroundStyle(.white)
								.offset(x: 15, y: -15)
						)
				}
		}
		.font(.system(size: 40))
		.fontWeight(.semibold)
		.padding(.horizontal, 20)
		.padding(.vertical)
	}
}

struct BookmarkListView: View {
	
	let onBookmarkAction: ()
	
	var body: some View {
		VStack(spacing: 15) {
			headerView
			
		} //:VSTACK
	}
	
	private var headerView: some View {
		HStack(spacing: 20) {
			Button {
				// Action
				
			} label: {
				Text("← Article Feeds")
					.foregroundStyle(.black.opacity(0.7))
			}
		} //:HSTACK
		.font(.system(size: 25))
		.fontWeight(.semibold)
		.padding(.horizontal, 20)
		.padding(.vertical)
	}
}

#Preview {
    ArticleBookmarkMGEView()
}

#Preview("북마크목록뷰") {
	BookmarkListView()
}
